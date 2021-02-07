//
//  Extensions_Segue.swift
//  Iris
//
//  Created by Shalin Shah on 1/9/20.
//  Copyright © 2020 Shalin Shah. All rights reserved.
//

import Foundation
import UIKit

// this for moving to next storyboard
extension UIStoryboard {
    func instantiateViewController<T: UIViewController>() -> T? {
        // get a class name and demangle for classes in Swift
        if let name = NSStringFromClass(T.self).components(separatedBy: ".").last {
            let next = instantiateViewController(withIdentifier: name) as? T
//            next!.modalPresentationStyle = .fullScreen
            return next
        }
        return nil
    }
    
    func instantiateViewControllerNoPresentation<T: UIViewController>() -> T? {
        // get a class name and demangle for classes in Swift
        if let name = NSStringFromClass(T.self).components(separatedBy: ".").last {
            let next = instantiateViewController(withIdentifier: name) as? T
            return next
        }
        return nil
    }

}


class PannableViewController: UIViewController {
    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer!)
    }

    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)

        if panGesture.state == .began {
            originalPosition = view.center
            currentPositionTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            view.frame.origin = CGPoint(
                x: self.view.frame.origin.x,
                y: max(translation.y, 0)
            )
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)

            if velocity.y >= 1500 || view.frame.origin.y > view.frame.size.height/2 - view.frame.size.height/4 {
                UIView.animate(withDuration: 0.2
                , animations: {
                    self.view.frame.origin = CGPoint(
                        x: self.view.frame.origin.x,
                        y: self.view.frame.size.height
                    )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = self.originalPosition!
                })
            }
        }
    }
}
