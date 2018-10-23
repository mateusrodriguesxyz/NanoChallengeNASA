//
//  PeekViewController.swift
//  NanoChallengeNASA
//
//  Created by Mateus Rodrigues on 19/10/18.
//  Copyright © 2018 Mateus Rodrigues. All rights reserved.
//

import UIKit
import CoreData

class PeekViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var image: UIImage?
    var imageData: Image?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        
        if let image = image {
            imageView.image = image
        }
        
        if let imageData = imageData {
            label.text = imageData.title
        }
    }
    
    override var previewActionItems: [UIPreviewActionItem] {
        let saveAction = UIPreviewAction(title: "Save to Favorites", style: .default,
            handler: { previewAction, viewController in
                
                if let data = self.image?.pngData() {
                    
                    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let filename = documentDirectory.appendingPathComponent("\(self.imageData!.id!)")
                    try? data.write(to: filename)
                    
                    guard let photo = self.imageData else {
                        return
                    }
                    
                    DBManager.shared.insertItem(id: photo.id!, title: photo.title!, description: photo.description!)
                    
                }
                
            })
        
        let removeAction = UIPreviewAction(title: "Delete from Favorites", style: .destructive,
             handler: { previewAction, viewController in
                
                let photo = DBManager.shared.fetchPhoto(id: (self.imageData?.id)!)
                
                let fileManager = FileManager.default
                let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                let path = documentDirectory.appendingPathComponent("\(self.imageData!.id!)")
                
                do {
                    try fileManager.removeItem(at: path)
                } catch {
                    
                }
                
                DBManager.shared.delete(photo: photo!)
                
            })
        
        let downloadAction = UIPreviewAction(title: "Download Image", style: .default,
        handler: { previewAction, viewController in
            print("Action Two Selected")
        })
        
        if (DBManager.shared.fetchPhoto(id: (imageData?.id!)!) != nil) {
            return [removeAction]
        } else {
            return [saveAction]
        }
        
    }

}
