//
//  Extensions_Design_Theme.swift
//  Iris
//
//  Created by Shalin Shah on 1/9/20.
//  Copyright © 2020 Shalin Shah. All rights reserved.
//

import Foundation
import UIKit


// for adding icons to labels
//import SwiftIconFont
//extension UIImage {
//    static func getImage(_ code: String, sideLength: Double = 50.0, color: UIColor = UIColor.darkGray) -> UIImage {
//        var prefix = "ios-"
//        if code.prefix(5) == "logo-" {
//            prefix = ""
//        }
//        var checked_code = prefix + code
//        if String.getIcon(from: .ionicon, code: checked_code) == nil {
//            checked_code = "ios-informacircle-outline"
//        }
//        return UIImage(from: Fonts.ionicon, code: checked_code, textColor: color, backgroundColor: UIColor.clear, size: CGSize(width: sideLength, height: sideLength))
//    }
//}

extension UILabel {
    func addIconToLabel(image: UIImage, text: String, imageOffsetY: CGFloat) {
        //Create Attachment
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = image
        //Set bound to reposition
                
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        //Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        //Add image to mutable string
        completeText.append(attachmentString)
        //Add your text to mutable string
        let  textAfterIcon = NSMutableAttributedString(string: " " + text)
        completeText.append(textAfterIcon)
        
        self.attributedText = completeText
   }
}


// for uicolors
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(displayP3Red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    struct ColorTheme {
        struct Gray {
            static let Silver = UIColor(displayP3Red: 196/255, green: 196/255, blue: 196/255, alpha: 1.0)
            static let MineShaft = UIColor(displayP3Red: 47/255, green: 47/255, blue: 47/255, alpha: 1.0)
        }
        
        struct Blue {
            static let Stratos = UIColor(displayP3Red: 3/255, green: 1/255, blue: 84/255, alpha: 1.0)
            static let Mirage = UIColor(displayP3Red: 20/255, green: 20/255, blue: 38/255, alpha: 1.0)
            static let BlackRussian = UIColor(displayP3Red: 1/255, green: 0/255, blue: 27/255, alpha: 1.0)
            static let Electric = UIColor(displayP3Red: 3/255, green: 0/255, blue: 153/255, alpha: 1.0)
            static let BlueRibbon = UIColor(netHex: 0x433CFF)
        }
        
        struct Pink {
            static let FuchsiaPink = UIColor(displayP3Red: 188/255, green: 63/255, blue: 188/255, alpha: 1.0)
            static let BrinkPink = UIColor(displayP3Red: 255/255, green: 99/255, blue: 147/255, alpha: 1.0)
        }
        
        struct Violet {
            static let VioletRed = UIColor(displayP3Red: 249/255, green: 59/255, blue: 118/255, alpha: 1.0)
            static let Heliotrope = UIColor(netHex: 0xC94EFF)
            static let ElectricViolet = UIColor(netHex: 0x7D47FF)
        }
    }
}
