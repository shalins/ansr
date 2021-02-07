//
//  FeedTableViewCell.swift
//  IrisLabs4
//
//  Created by Shalin on 10/28/20.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel! {
        didSet {
            self.title.layer.shouldRasterize = true
            self.title.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    @IBOutlet weak var time: UILabel! {
        didSet {
            self.time.layer.shouldRasterize = true
            self.time.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    @IBOutlet weak var needs: UILabel! {
        didSet {
            self.needs.layer.shouldRasterize = true
            self.needs.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    @IBOutlet weak var canGive: UILabel! {
        didSet {
            self.canGive.layer.shouldRasterize = true
            self.canGive.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    @IBOutlet weak var profile: UIImageView! {
           didSet {
               self.profile.layer.shouldRasterize = true
               self.profile.layer.rasterizationScale = UIScreen.main.scale
           }
       }
    
    @IBOutlet weak var more: UIButton! {
           didSet {
               self.more.layer.shouldRasterize = true
               self.more.layer.rasterizationScale = UIScreen.main.scale
           }
       }

    override func awakeFromNib() {
        super.awakeFromNib()
    
        let mScreenSize = UIScreen.main.bounds
        let mSeparatorHeight = CGFloat(3.0) // Change height of speatator as you want
        let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
        mAddSeparator.backgroundColor = UIColor.black // Change backgroundColor of separator
        self.addSubview(mAddSeparator)

        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    
}
