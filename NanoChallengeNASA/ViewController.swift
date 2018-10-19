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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var images: [Image] = []
    
    let imageCache = NSCache<NSString, UIImage>()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        
        searchBar.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
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
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        let searchString = searchBar.text?.lowercased().replacingOccurrences(of: " ", with: "+") ?? ""
        
        APIManager.shared.searchImage(query: searchString) { (images, error) in
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            guard let images = images else {
                return
            }
            
            self.images = images
            
            DispatchQueue.main.async {
                
                for (index, image) in self.images.enumerated() {
                    print(index, image.imageSize)
                }
                if !self.images.isEmpty {
                    self.collectionView.reloadData()
                }
                self.searchBar.resignFirstResponder()
            }
        }
        
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func downloadImage(url: URL, completion: @escaping (URL, UIImage?, Error?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(url, cachedImage, nil)
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(url, nil, error)
                    
                } else if let data = data, let image = UIImage(data: data) {
                    self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(url, image, nil)
                } else {
                    completion(url, nil, NSError(domain: url.absoluteString, code: 0, userInfo: nil))
                }
                }.resume()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(images.count)
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        let image = images[indexPath.item]
        
        downloadImage(url: image.thumbUrl!) { (url, image, error) in
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        }
        
        return cell
    }
    
}

extension ViewController : PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        return images[indexPath.item].imageSize ?? CGSize(width: 200, height: 200)
    }
    
}

