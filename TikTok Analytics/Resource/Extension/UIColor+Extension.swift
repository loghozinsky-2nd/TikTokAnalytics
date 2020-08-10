//
//  UIColor+ThemeColor.swift
//  TikTok Analytics
//
//  Created by Aleksander Logozinsky on 05.08.2020.
//

import UIKit

extension UIColor {
    open class var theme: UIColor {
        get {
            UIColor(red: 0.123, green: 0.06, blue: 0.204, alpha: 1)
        }
    }
    
    open class var themeWhiteTransparent: UIColor {
        get {
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.15)
        }
    }
    
    open class var themeGray: UIColor {
        get {
            UIColor(red: 0.575, green: 0.575, blue: 0.575, alpha: 1)
        }
    }
    
    open class var themePink: UIColor {
        get {
            UIColor(red: 0.924, green: 0.858, blue: 1, alpha: 1)
        }
    }
    
    open class var themeDarkenPink: UIColor {
        get {
            UIColor(red: 0.123, green: 0.06, blue: 0.204, alpha: 1)
        }
    }
    
    open class var themeDarken: UIColor {
        get {
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        }
    }
}
