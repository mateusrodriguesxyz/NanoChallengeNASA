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
            imageView.backgroundColor = .white
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.contentView.layer.cornerRadius = 5
//        self.contentView.backgroundColor = .blue
        // Initialization code
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }

}
