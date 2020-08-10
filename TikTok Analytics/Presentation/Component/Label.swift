//
//  Label.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 07.08.2020.
//

import UIKit

class Label: UILabel {
    
    let custom = NSAttributedString.Key.self
    
    var color: UIColor!
    var size: CGFloat!
    var weight: UIFont.Weight!
    var kern: CGFloat!
    var strikethroughStyle: Int!
    let paragraphStyle = NSMutableParagraphStyle()
    
    func setValue(_ value: String, size: CGFloat = 17, isScalable: Bool = false, lineHeight: CGFloat = 1.01, fontWeight: UIFont.Weight = .regular, numberOfLines: Int = 0, color: UIColor = .white, kern: CGFloat = -0.3, lineBreakMode: NSLineBreakMode = .byWordWrapping, strikethroughStyle: Int = 0, textAlignment: NSTextAlignment = .left) {
        self.numberOfLines = numberOfLines
        self.color = color
        self.size = isScalable && UIDevice.isPad ? size * 2 : size
        self.weight = fontWeight
        self.kern = kern
        self.strikethroughStyle = strikethroughStyle
        self.paragraphStyle.alignment = textAlignment
        self.paragraphStyle.lineBreakMode = lineBreakMode
        self.paragraphStyle.lineHeightMultiple = lineHeight
        
        setAttributedText(value)
    }
    
    func setAttributedText(_ string: String?, withColor color: UIColor? = nil) {
        let string: String = string != nil ? string! : ""
        let color: UIColor = color != nil ? color! : self.color
        self.attributedText = NSMutableAttributedString(string: string, attributes: [
            custom.foregroundColor: color,
            custom.kern: kern ?? -0.41,
            custom.font: weight == .regular ? UIFont.sfprodisplay(ofSize: size) : UIFont.roboto(ofSize: size),
            custom.strikethroughStyle: strikethroughStyle!,
            custom.paragraphStyle: paragraphStyle
        ])
    }
    
    func setColor(color: UIColor) {
        setAttributedText(text, withColor: color)
    }
    
}
