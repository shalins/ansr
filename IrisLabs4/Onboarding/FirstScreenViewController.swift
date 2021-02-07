//
//  FirstScreenViewController.swift
//  Iris
//
//  Created by Shalin Shah on 2/4/20.
//  Copyright © 2020 Shalin Shah. All rights reserved.
//

import UIKit

class FirstScreenViewController: UIViewController {
    
    @IBOutlet weak var roundedView: UIView! {
        didSet {
            self.roundedView.addTopRoundedEdge(desiredCurve: 1.0)
            self.roundedView.layer.backgroundColor = UIColor.ColorTheme.Blue.Mirage.cgColor

            self.roundedView.layer.shouldRasterize = true
            self.roundedView.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    @IBOutlet weak var borderRoundedView: UIView! {
        didSet {
            self.borderRoundedView.addTopRoundedEdge(desiredCurve: 1.0)

            self.borderRoundedView.layer.shouldRasterize = true
            self.borderRoundedView.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            self.titleLabel.layer.shouldRasterize = true
            self.titleLabel.layer.rasterizationScale = UIScreen.main.scale
        }
    }
        
    @IBOutlet weak var answerButtonBackgroundView: UIView! {
        didSet {
            self.answerButtonBackgroundView.layer.shouldRasterize = true
            self.answerButtonBackgroundView.layer.rasterizationScale = UIScreen.main.scale
        }
    }

    @IBOutlet weak var answerButton: UIButton! {
        didSet {
            self.answerButton.layer.shouldRasterize = true
            self.answerButton.layer.rasterizationScale = UIScreen.main.scale
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.shouldRasterize = true
        self.view.layer.rasterizationScale = UIScreen.main.scale
    }

    @IBAction func rebelButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let next: EnterNumberViewController? = self.storyboard?.instantiateViewController()
            self.show(next!, sender: self)
        }
    }
    
}
