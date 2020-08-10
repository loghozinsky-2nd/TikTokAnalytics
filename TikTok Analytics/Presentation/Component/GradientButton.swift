//
//  GradientButton.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 06.08.2020.
//

import UIKit

class GradientButton: UIButton {
    
    let attributedString = [NSAttributedString.Key.font : UIFont.sfprodisplay(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.white]

    convenience init(withText text: String) {
        self.init()
        
        layer.cornerRadius = 15
        clipsToBounds = true
        layer.opacity = 0
        
        setBackgroundImage(#imageLiteral(resourceName: "gradient"), for: .normal)
        setAttributedTitle(text)
    }
    
    func setAttributedTitle(_ text: String) {
        let attributedTitleForNormal = NSMutableAttributedString(string: text, attributes: attributedString)
        setAttributedTitle(attributedTitleForNormal, for: .normal)
    }

}
