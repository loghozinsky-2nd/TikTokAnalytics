//
//  UIFont+Extension.swift
//  TikTok Analytics
//
//  Created by Aleksander Logozinsky on 05.08.2020.
//

import UIKit

extension UIFont {
    open class func roboto(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: fontSize)!
    }
    
    open class func sfprodisplay(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "SFProDisplay-Medium", size: fontSize)!
    }
}
