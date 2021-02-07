//
//  SettingsMultiSelectTableViewCell.swift
//  Iris
//
//  Created by Shalin Shah on 1/23/20.
//  Copyright © 2020 Shalin Shah. All rights reserved.
//

import UIKit

class ClassesMultiSelectTableViewCell: UITableViewCell {
    
    var id: String!
    
    @IBOutlet weak var title: UILabel! {
        didSet {
            self.title.layer.shouldRasterize = true
            self.title.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    @IBOutlet weak var checkBox: UIImageView! {
           didSet {
               self.checkBox.layer.shouldRasterize = true
               self.checkBox.layer.rasterizationScale = UIScreen.main.scale
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
