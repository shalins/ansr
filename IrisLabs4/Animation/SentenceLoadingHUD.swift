//
//  SentenceLoading.swift
//  Iris
//
//  Created by Shalin Shah on 2/8/20.
//  Copyright © 2020 Shalin Shah. All rights reserved.
//

import UIKit

class SentenceLoadingHUD: UIView {
    
    var topLine: UIView!
    var bottomLine: UIView!
    var colorVal: Int! = 0
    var colorTimer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.topLine = UIView(frame: CGRect(x: 0, y: 24, width: self.frame.width, height: 20))
        self.topLine.makeCorner(withRadius: self.topLine.frame.height / 2)

        self.bottomLine = UIView(frame: CGRect(x: 0, y: 72, width: self.frame.width, height: 20))
        self.bottomLine.makeCorner(withRadius: self.topLine.frame.height / 2)
        
        self.addSubview(bottomLine)
        self.addSubview(topLine)
        
        if self.colorTimer == nil {
            self.changeColor()
            self.colorTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(changeColor), userInfo: nil, repeats: true)
        }

        self.backgroundColor = UIColor.black

        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.topLine.layer.shouldRasterize = true
        self.topLine.layer.rasterizationScale = UIScreen.main.scale
        self.bottomLine.layer.shouldRasterize = true
        self.bottomLine.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func invalidateTimer() {
        self.colorTimer?.invalidate()
        self.colorTimer = nil
    }
    
    @objc func changeColor() {
        self.colorVal = self.colorVal == 0 ? 1 : 0
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveLinear, animations: {
            self.topLine.backgroundColor = self.colorVal == 0 ? UIColor.ColorTheme.Blue.Mirage : UIColor.ColorTheme.Blue.Stratos
            self.bottomLine.backgroundColor = self.colorVal == 0 ? UIColor.ColorTheme.Blue.Mirage : UIColor.ColorTheme.Blue.Stratos
        }, completion: nil)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
