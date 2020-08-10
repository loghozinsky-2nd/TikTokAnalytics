//
//  ImageView.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 07.08.2020.
//

import UIKit

class ImageView: UIImageView {
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
