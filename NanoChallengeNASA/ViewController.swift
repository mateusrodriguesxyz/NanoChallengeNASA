//
//  ViewController.swift
//  NanoChallengeNASA
//
//  Created by Mateus Rodrigues on 18/10/18.
//  Copyright © 2018 Mateus Rodrigues. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: [Image] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }

}

extension ViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchString = searchBar.text?.lowercased().replacingOccurrences(of: " ", with: "+") ?? ""
        
        APIManager.shared.searchImage(query: searchString) { (images, error) in
            guard let images = images else {
                return
            }
            
            self.images = images
            
            DispatchQueue.main.async {
                
                self.images.forEach({ (image) in
                    print(image.imageSize ?? "none")
                })
                
                self.collectionView.reloadData()
            }
        }
        
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(images.count)
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = .blue
        return cell
    }
    
    
}

