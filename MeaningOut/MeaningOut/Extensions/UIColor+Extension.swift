//
//  UIColor+Extension.swift
//  MeaningOut
//
//  Created by user on 6/13/24.
//

import UIKit


extension UIColor {
    static func hexToColor(_ hexValue: String) -> UIColor? {
        let r, g, b: CGFloat
        
        guard let hexValue = hexValue.removeOnePrefix("#") else { return nil }
        if hexValue.count == 6 {
            let scanner = Scanner(string: hexValue)
            var hexNumber: UInt64 = 0
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
                b = CGFloat((hexNumber & 0x0000FF)) / 255
                
                
                return UIColor(red: r, green: g, blue: b, alpha: 1)
            }
        }
        return nil
    }
}
