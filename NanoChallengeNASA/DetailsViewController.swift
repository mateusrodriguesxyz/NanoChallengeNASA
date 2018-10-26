//
//  DetaisViewController.swift
//  NanoChallengeNASA
//
//  Created by Mateus Rodrigues on 19/10/18.
//  Copyright © 2018 Mateus Rodrigues. All rights reserved.
//

import UIKit
import AVFoundation

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var imageConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var contentConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var textConstraintHeight: NSLayoutConstraint!
    
    var imageData: Image?
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = imageData?.title
        
        if let image = image {
            
            let boundingRect = CGRect(x: 0, y: 0, width: imageView.frame.width, height: CGFloat(MAXFLOAT))
            let proportionalSize = AVMakeRect(aspectRatio: image.size, insideRect: boundingRect)
            
            imageConstraintHeight.constant = proportionalSize.size.height
    
            imageView.image = image
            
            textView.text = imageData?.description
            textConstraintHeight.constant = textView.contentSize.height

            contentConstraintHeight.constant = imageConstraintHeight.constant + textConstraintHeight.constant + 40
            
        }

    }

}
