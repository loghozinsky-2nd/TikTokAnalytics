//
//  VerticalGradientButton.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 11.08.2020.
//

import UIKit

class VerticalGradientButton: UIButton {
    
    let attributedString = [NSAttributedString.Key.font : UIFont.balootamma(ofSize: 24), NSAttributedString.Key.foregroundColor : UIColor.white]
    
    convenience init(withText text: String) {
        self.init()
        
        layer.cornerRadius = 59
        clipsToBounds = true
        layer.opacity = 1
        
        setBackgroundImage(#imageLiteral(resourceName: "gradient"), for: .normal)
        setAttributedTitle(text)
    }
    
    func setAttributedTitle(_ text: String) {
        let attributedTitleForNormal = NSMutableAttributedString(string: text, attributes: attributedString)
        setAttributedTitle(attributedTitleForNormal, for: .normal)
    }

}
