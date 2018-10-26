//
//  FavoritesViewController.swift
//  NanoChallengeNASA
//
//  Created by Mateus Rodrigues on 22/10/18.
//  Copyright © 2018 Mateus Rodrigues. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    
    var favorites: [Photo] = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
            layout.numberOfColumns = 2
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.isEditing = false
        
        favorites = DBManager.shared.fetchAllPhotos()
        collectionView.reloadData()
        
    }
    
    func getImage(id: String) -> UIImage? {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let path = documentDirectory.appendingPathComponent(id)
        do {
            let data = try Data(contentsOf: path)
            return UIImage(data: data)
        } catch {
            print(error)
            return nil
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if let indexPaths = collectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths {
                let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
                cell.isEditing = editing
                
            }
        }
        
        collectionView.reloadData()
        
        
    }
    
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let photo = favorites[indexPath.item]
        
        cell.imageView.image = getImage(id: photo.id!)
        cell.imageView.contentMode = .scaleAspectFill
        cell.isEditing = self.isEditing
        
        cell.delegate = self
        
        return cell
    }
}

extension FavoritesViewController: CellDelegate {
    func delete(cell: CollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let photo = favorites[indexPath.item]
            DBManager.shared.delete(photo: photo)
            favorites.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
            
        }
    }
}

extension FavoritesViewController : PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        let photo = favorites[indexPath.item]
        let image = getImage(id: photo.id!)
        return image?.size ?? CGSize(width: 200, height: 200)
    }
    
}
