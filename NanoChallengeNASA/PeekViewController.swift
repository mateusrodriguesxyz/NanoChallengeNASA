//
//  PeekViewController.swift
//  NanoChallengeNASA
//
//  Created by Mateus Rodrigues on 19/10/18.
//  Copyright © 2018 Mateus Rodrigues. All rights reserved.
//

import UIKit

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
        let action1 = UIPreviewAction(title: "Save to Favorites", style: .default,
        handler: { previewAction, viewController in
            print("Action One Selected")
        })
        
        let action2 = UIPreviewAction(title: "Download Image", style: .default,
        handler: { previewAction, viewController in
            print("Action Two Selected")
        })
        
        return [action1, action2]
    }

}
