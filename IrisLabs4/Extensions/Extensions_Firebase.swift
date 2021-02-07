//
//  Extensions_Firebase.swift
//  Iris
//
//  Created by Shalin Shah on 1/9/20.
//  Copyright © 2020 Shalin Shah. All rights reserved.
//

import Foundation
import UIKit

// firebase specific things
extension UIViewController {
    func formatNumber(number: String) -> String {
        let currentNum = number.trimmingCharacters(in: CharacterSet(charactersIn: "+01234567890").inverted)
        let finalPN = currentNum.contains("+1") ? currentNum : "+1" + currentNum
        return finalPN
    }
    
    func checkNameString(name: String) -> (String, String) {
        let fullName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (((fullName.components(separatedBy: " ").count) < 1) || (fullName.trimmingCharacters(in: .whitespaces).isEmpty)) {
            return (fullName, "Enter your first name")
        } else if (fullName.trimmingCharacters(in: .whitespaces).count) < 2 {
            return (fullName, "What you entered is too short")
        } else if (fullName.trimmingCharacters(in: .whitespaces).count) > 20 {
            return (fullName, "What you entered is too long")
        } else {
            return (fullName, "Okay")
        }
    }
}

extension Date {
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        
        guard let timeString = formatter.string(from: self, to: Date()) else {
            return nil
        }
        
        let formatString = NSLocalizedString("%@ ago", comment: "")
        return String(format: formatString, timeString)
    }
}

extension UIViewController {
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
