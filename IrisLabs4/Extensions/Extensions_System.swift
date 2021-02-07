//
//  Extensions_System.swift
//  Iris
//
//  Created by Shalin Shah on 1/9/20.
//  Copyright © 2020 Shalin Shah. All rights reserved.
//

import Foundation
import UIKit

// this is for alerts and action sheets
extension UIViewController {
    func showAlert(message: String? = nil, title: String? = nil, completionHandler:@escaping (String) -> ()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                  switch action.style{
                  case .default:
                    completionHandler("default")

                  case .cancel:
                    completionHandler("cancel")

                  case .destructive:
                    completionHandler("destructive")

                  @unknown default:
                    fatalError()
                }}))
            alert.modalPresentationStyle = .overFullScreen
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showActionSheet(title: String? = nil, message: String? = nil, optionTitle: String? = nil,  completionHandler:@escaping (String) -> ()) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: optionTitle, style: .default , handler:{ (UIAlertAction)in
            completionHandler("default")
        }))

        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
            completionHandler("destructive")
        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            completionHandler("cancel")
        }))
        
        actionSheet.modalPresentationStyle = .overFullScreen
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dismissKeyboardSearch(searchController: UISearchController) {
        searchController.isActive = false
        searchController.searchBar.resignFirstResponder()
        self.dismissKeyboard()
    }
    
    func delay(_ delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }

}

class SwitchWithRowAndSection : UISwitch {
    var row : Int?
    var section : Int?
}

class ButtonWithRowAndSection : UIButton {
    var row : Int?
    var section : Int?
}


// this is for calculating the height / width of a label from a string
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.width)
    }
}


extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}
