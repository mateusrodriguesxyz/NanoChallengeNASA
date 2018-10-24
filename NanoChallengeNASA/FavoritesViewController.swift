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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        cell.isEditing = true
        
        return cell
    }
}
