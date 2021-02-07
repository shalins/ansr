//
//  Extensions_Animations.swift
//  Iris
//
//  Created by Shalin Shah on 1/9/20.
//  Copyright © 2020 Shalin Shah. All rights reserved.
//

import Foundation
import UIKit

// this is for showing the loading animation on the view controller
extension UIViewController {
    func addAnimation() -> LoadingHUD {
        let newLoader = LoadingHUD.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        DispatchQueue.main.async {
            self.view.addSubview(newLoader)
        }
        return newLoader
    }
    
    func removeAnimation(loader: LoadingHUD?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                if (loader != nil) {
                    loader!.removeFromSuperview()
                }
            })
        }
    }
    
    func addSentenceAnimation(view: UIView) -> SentenceLoadingHUD {
        let newLoader = SentenceLoadingHUD.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 120))
        DispatchQueue.main.async {
            view.addSubview(newLoader)
        }
        return newLoader
    }
    
    func removeSentenceAnimation(loader: SentenceLoadingHUD?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                if (loader != nil) {
                    loader?.alpha = 0.0
                }
            }, completion: { finished in
                if (loader != nil) {
                    loader!.invalidateTimer()
                    loader!.removeFromSuperview()
                }
            })
        }
    }
}

extension UICollectionViewCell {
    func addTableAnimation() -> TableLoadingHUD {
        let newLoader = TableLoadingHUD.init(frame: CGRect(x: 0, y: 34, width: UIScreen.main.bounds.size.width, height: 170))
        DispatchQueue.main.async {
            self.addSubview(newLoader)
        }
        return newLoader
    }
    
    func removeTableAnimation(loader: TableLoadingHUD?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
                if (loader != nil) {
                    loader?.alpha = 0.0
                }
            }, completion: { finished in
                if (loader != nil) {
                    loader!.invalidateTimer()
                    loader!.removeFromSuperview()
                }
            })
        }
    }
}

extension UIButton {
    private static let kRotationAnimationKey = "rotationanimationkey"

    func rotate(duration: Double = 1.5) {
        if layer.animation(forKey: UIButton.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity

            layer.add(rotationAnimation, forKey: UIButton.kRotationAnimationKey)
        }
    }

    func stopRotating() {
        if layer.animation(forKey: UIButton.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIButton.kRotationAnimationKey)
        }
    }
}


