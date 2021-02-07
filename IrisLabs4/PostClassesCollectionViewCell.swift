//
//  PostClassesCollectionViewCell.swift
//  IrisLabs4
//
//  Created by Shalin on 10/29/20.
//

import UIKit

class PostClassesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var background: UIImageView! {
        didSet {
            self.background.layer.shouldRasterize = true
            self.background.layer.rasterizationScale = UIScreen.main.scale
        }
    }

    
    @IBOutlet weak var title: UILabel! {
        didSet {
            self.title.layer.shouldRasterize = true
            self.title.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

}
