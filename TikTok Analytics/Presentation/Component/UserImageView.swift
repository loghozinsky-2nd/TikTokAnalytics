//
//  UserImageView.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 07.08.2020.
//

import UIKit

class UserImageView: UIImageView {
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        layer.masksToBounds = true
        if UIDevice.isPhone { layer.cornerRadius = 15 } else if UIDevice.isPad { layer.cornerRadius = 35 }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bordering() {
        let borderLayer = CALayer()
        let borderImage = #imageLiteral(resourceName: "border").cgImage
        borderLayer.contents = borderImage
        borderLayer.frame = CGRect(origin: .zero, size: frame.size)
        layer.insertSublayer(borderLayer, above: layer)
    }
    
}
