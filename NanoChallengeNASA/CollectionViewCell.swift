//
//  CollectionViewCell.swift
//  NanoChallengeNASA
//
//  Created by Mateus Rodrigues on 18/10/18.
//  Copyright © 2018 Mateus Rodrigues. All rights reserved.
//

import UIKit

protocol CellDelegate: class {
    func delete(cell: CollectionViewCell)
}

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
            blurView.alpha = 0
        }
    }
    
    var isEditing : Bool = false {
        didSet {
            let editing: CGFloat = self.isEditing ? 0 : 1
            if (blurView.alpha == editing) {
                self.blurView.alpha = editing
                UIView.animate(withDuration: 0.3, animations: {
                    self.blurView.alpha = self.isEditing ? 1 : 0
                }) { (finished) in
                }
            }
        }
    }
    
    weak var delegate: CellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }

    @IBAction func deleteButtonDidTap(_ sender: Any) {
        delegate?.delete(cell: self)
    }
}
