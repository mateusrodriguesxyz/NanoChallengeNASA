//
//  APIManager.swift
//  NanoChallengeNASA
//
//  Created by Mateus Rodrigues on 18/10/18.
//  Copyright © 2018 Mateus Rodrigues. All rights reserved.
//

import Foundation
import UIKit

class APIManager {
    
    let imageCache = NSCache<NSString, UIImage>()
    
    static let shared = APIManager()
    
    func searchImage(query: String, completion: @escaping ([Image]?, Error?) -> Void) {
        
        let url = URL(string: "https://images-api.nasa.gov/search?q=\(query)&media_type=image")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                self.downloadMetadata(images: response.items, completion: { (images, error) in
                    if (error != nil) {
                        completion(nil, error)
                    } else {
                        completion(images, error)
                    }
                })
                
                
                
            } catch {
                completion(nil, error)
            }
            }.resume()
    }
        
    private func downloadMetadata(images: [Image], completion: @escaping ([Image]?, Error?) -> Void) {
        
        let group = DispatchGroup()
        
        var images = images
        
        for (index, image) in images.enumerated() {
            let id = (image.id)!
            
            let metadataUrl = "https://images-assets.nasa.gov/image/\(id)/metadata.json"
            
            let url = URL(string: metadataUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
            
            group.enter()
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                do {
                    let decoder = JSONDecoder()
                    let metadata = try decoder.decode(Metadata.self, from: data!)
                    images[index].setSize(width: metadata.fileImageWidth ?? metadata.exifImageWidth, height: metadata.fileImageHeight ?? metadata.exifImageHeight)
                } catch {
                    print(error)
                }
                group.leave()
                }.resume()
            
        }
        
        group.notify(queue: .main) {
            print("Finished all requests.")
            completion(images, nil)
        }
    }
    
}
