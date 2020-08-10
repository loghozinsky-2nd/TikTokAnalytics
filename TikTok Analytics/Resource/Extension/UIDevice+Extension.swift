//
//  UIDevice+Extension.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 07.08.2020.
//

import UIKit

public extension UIDevice {
    
    class var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    class var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
}
