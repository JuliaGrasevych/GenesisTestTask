//
//  UIColor+Hex.swift
//  GenesisTestTask
//
//  Created by Julia on 9/14/18.
//  Copyright © 2018 Julia. All rights reserved.
//

import UIKit

extension UIColor {
    /// Initialize color with hex value (withou alpha channel)
    public convenience init?(hexString: String) {
        let red, green, blue: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    red = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    blue = CGFloat(hexNumber & 0x0000ff) / 255
                    
                    self.init(red: red, green: green, blue: blue, alpha: 1.0)
                    return
                }
            }
        }
        return nil
    }
}
