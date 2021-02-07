//
//  ReachabilityView.swift
//  Iris
//
//  Created by Shalin Shah on 2/9/20.
//  Copyright © 2020 Shalin Shah. All rights reserved.
//

import UIKit

protocol ErrorViewDelegate: class {
    func tryAgainPushed()
}

class ErrorView: UIView {
    
    weak var delegate: ErrorViewDelegate?

    var title: UILabel!
    var image: UIImageView!
    var sentence: UILabel!
    var refreshButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let padding = frame.height / 12
        let startPoint = frame.height / 5
        
        self.title = UILabel(frame: CGRect(x: 22, y: startPoint, width: self.frame.width-44, height: 30))
        self.title.textAlignment = .center
        self.title.text = "Oops we did it again!"
        self.title.font = UIFont(name: "Courier-Bold", size: 24)
        self.title.textColor = .white

        let spaceOne = self.title.frame.maxY + (padding/2)
        
        self.image = UIImageView(frame: CGRect(x: self.center.x - (125/2), y: spaceOne, width: 115, height: 115))
        self.image.image = #imageLiteral(resourceName: "sad")

        let spaceTwo = self.image.frame.maxY + (padding/2)
        
        self.sentence = UILabel(frame: CGRect(x: 22, y: spaceTwo, width: self.frame.width-44, height: 60))
        self.sentence.numberOfLines = 4
        self.sentence.textAlignment = .center
        self.sentence.text = "Ok, we didn’t expect this.  An error occurred, and we’re working on solving this now."
        self.sentence.font = UIFont(name: "Courier", size: 14)
        self.sentence.textColor = .white
        
        let spaceThree = self.sentence.frame.maxY + (padding/2)

        self.refreshButton = UIButton(frame: CGRect(x: self.center.x - (170/2), y: spaceThree, width: 170, height: 46))
        self.refreshButton.setTitle("Try Again", for: .normal)
        self.refreshButton.backgroundColor = UIColor.ColorTheme.Blue.Electric
        self.refreshButton.makeCorner(withRadius: 8)
        self.refreshButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.refreshButton.titleLabel?.font = UIFont(name: "Courier-Bold", size: 16)
        self.refreshButton.isEnabled = true
        self.refreshButton.setTitleColor(.white, for: .normal)

        self.addSubview(title)
        self.addSubview(image)
        self.addSubview(sentence)
        self.addSubview(refreshButton)

        self.backgroundColor = UIColor.ColorTheme.Blue.Mirage

        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.title.layer.shouldRasterize = true
        self.title.layer.rasterizationScale = UIScreen.main.scale
        self.image.layer.shouldRasterize = true
        self.image.layer.rasterizationScale = UIScreen.main.scale
        self.sentence.layer.shouldRasterize = true
        self.sentence.layer.rasterizationScale = UIScreen.main.scale
        self.refreshButton.layer.shouldRasterize = true
        self.refreshButton.layer.rasterizationScale = UIScreen.main.scale
    }
    
    @objc func buttonTapped() {
        print("button tapped")
        DispatchQueue.main.async {
            UIView.transition(with: self.refreshButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.refreshButton.backgroundColor = UIColor.ColorTheme.Blue.Stratos
                self.refreshButton.isEnabled = false
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.transition(with: self.refreshButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.refreshButton.backgroundColor = UIColor.ColorTheme.Blue.Electric
                    self.refreshButton.isEnabled = true
                })
            }
            self.delegate?.tryAgainPushed()
        }
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
