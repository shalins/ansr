//
//  LoadingHUD.swift
//  Iris
//
//  Created by Shalin Shah on 1/7/20.
//  Copyright © 2020 Shalin Shah. All rights reserved.
//

import UIKit
import Lottie

class LoadingHUD: UIView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(1.0)

        let animationView = AnimationView(name: "loading_animation")
        animationView.frame = CGRect(x: (UIScreen.main.bounds.size.width/2)-100, y: (UIScreen.main.bounds.size.height/2)-100, width: 200, height: 200)
        animationView.loopMode = LottieLoopMode.loop
        self.addSubview(animationView)
        animationView.play{ (finished) in
            // playing
        }
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        animationView.layer.shouldRasterize = true
        animationView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
