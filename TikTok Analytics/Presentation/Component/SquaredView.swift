//
//  SquaredView.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 07.08.2020.
//

import UIKit

class SquaredView: UIView, CountValueFormatter {
    
    let countLabel = Label()
    let descriptionLabel = Label()
    
    func setValue(count: String, description: String) {
        countLabel.setValue(formatCountValue(countLabel: count), size: UIDevice.isPhone ? 14 : 18, numberOfLines: 1, textAlignment: .center)
        descriptionLabel.setValue(description, size: UIDevice.isPhone ? 9 : 13, numberOfLines: 1, textAlignment: .center)
        
        setupLayout()
    }
    
    private func setupLayout() {
        backgroundColor = .themeWhiteTransparent
        addSubviews(countLabel, descriptionLabel)
        
        countLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        countLabel.anchor(bottom: centerYAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom:  UIDevice.isPhone ? 4 : 0, right: 0))
        
        descriptionLabel.anchor(top: centerYAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 4, left: 0, bottom: 5, right: 0))
        
        layer.masksToBounds = true
        layer.cornerRadius = 7
    }

}
