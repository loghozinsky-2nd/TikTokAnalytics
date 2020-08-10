//
//  UsernameField.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 06.08.2020.
//

import UIKit

class UsernameField: UITextField {
    
    convenience init(withPlaceholder text: String) {
        self.init()
        
        let placeholder = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont.sfprodisplay(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.themeGray, NSAttributedString.Key.kern: 0.16])
        attributedPlaceholder = placeholder
        font = UIFont.sfprodisplay(ofSize: 14)
        textAlignment = .center
        tintColor = .theme
        textColor = .theme
        backgroundColor = .white
        layer.masksToBounds = true
        layer.cornerRadius = 15
        layer.opacity = 0
        autocapitalizationType = .none
        autocorrectionType = .no
        endEditing(false)
    }
    
    func a() {

    }

}
