//
//  TableLoadingHUD.swift
//  Iris
//
//  Created by Shalin Shah on 3/3/20.
//  Copyright © 2020 Shalin Shah. All rights reserved.
//

import UIKit

class TableLoadingHUD: UIView {
    
    var backgroundBorder: UIView!
    var progressLine: UIView!
    var colorVal: Int! = 0
    var colorTimer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundBorder = UIView(frame: CGRect(x: 22, y: 0, width: self.frame.width-44, height: 170))
        self.backgroundBorder.makeCorner(withRadius: 8)
        self.backgroundBorder.backgroundColor = UIColor.ColorTheme.Blue.BlackRussian
        
        self.progressLine = UIView(frame: CGRect(x: 32, y: 70, width: self.frame.width-101, height: 14))
        self.progressLine.makeCorner(withRadius: self.progressLine.frame.height / 2)

        self.addSubview(backgroundBorder)
        self.addSubview(progressLine)
        
        if self.colorTimer == nil {
            self.changeColor()
            self.colorTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changeColor), userInfo: nil, repeats: true)
        }

        self.backgroundColor = UIColor.clear

        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.backgroundBorder.layer.shouldRasterize = true
        self.backgroundBorder.layer.rasterizationScale = UIScreen.main.scale
        self.progressLine.layer.shouldRasterize = true
        self.progressLine.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func invalidateTimer() {
        self.colorTimer?.invalidate()
        self.colorTimer = nil
    }
    
    @objc func changeColor() {
        self.colorVal = self.colorVal == 0 ? 1 : 0
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
            self.progressLine.backgroundColor = self.colorVal == 0 ? UIColor.ColorTheme.Blue.Mirage : UIColor.ColorTheme.Blue.BlackRussian
        }, completion: nil)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
