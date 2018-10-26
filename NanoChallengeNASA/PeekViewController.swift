//
//  PeekViewController.swift
//  NanoChallengeNASA
//
//  Created by Mateus Rodrigues on 19/10/18.
//  Copyright © 2018 Mateus Rodrigues. All rights reserved.
//

import UIKit
import CoreData

protocol ActivityViewDelegate: class {
    func showActivity(image: UIImage)
}

class PeekViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var image: UIImage?
    var imageData: Image?
    
    weak var delegate: ActivityViewDelegate?
    
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
                guard let photo = self.imageData else {
                    return
                }
                
                DispatchQueue.main.async {
                    DBManager.shared.insertItem(id: photo.id!, title: photo.title!, description: photo.description!, image: self.image)
                }
                
            })
        
        let removeAction = UIPreviewAction(title: "Delete from Favorites", style: .destructive,
             handler: { previewAction, viewController in
                
                let photo = DBManager.shared.fetchPhoto(id: (self.imageData?.id)!)
                
                DBManager.shared.delete(photo: photo!)
                
            })
        
        let shareAction = UIPreviewAction(title: "Share Image", style: .default,
        handler: { previewAction, viewController in
            self.delegate?.showActivity(image: self.image!)
        })
        
        if (DBManager.shared.fetchPhoto(id: (imageData?.id!)!) != nil) {
            return [removeAction, shareAction]
        } else {
            return [saveAction, shareAction]
        }
        
    }

}
