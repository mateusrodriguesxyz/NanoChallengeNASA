//
//  CollectionViewCell.swift
//  NanoChallengeNASA
//
//  Created by Mateus Rodrigues on 18/10/18.
//  Copyright © 2018 Mateus Rodrigues. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 5
            imageView.backgroundColor = UIColor.darkGray
        }
    }
    @IBOutlet weak var blurView: UIVisualEffectView! {
        didSet {
            blurView.layer.cornerRadius = blurView.bounds.width/2.0
            blurView.layer.masksToBounds = true
        }
    }
    
    var isEditing : Bool = false {
        didSet {
            blurView.isHidden = !isEditing
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }

    @IBAction func deleteButtonDidTap(_ sender: Any) {
        
    }
}
