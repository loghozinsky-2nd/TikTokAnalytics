//
//  SquareCollectionViewCell.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 07.08.2020.
//

import UIKit

class SquaredCollectionViewCell: UICollectionViewCell, CountValueFormatter {
    
    static let reuseIdentifier = String(describing: self)
    
    let countLabel = Label()
    let descriptionLabel = Label()
    let iconImageView = ImageView(image: UIImage())
    
    func setValue(count: String, description: String, image: UIImage) {
        countLabel.setValue(formatCountValue(countLabel: count), size: UIDevice.isPhone ? 14 : 18, numberOfLines: 1, color: .themeDarkenPink, textAlignment: .center)
        descriptionLabel.setValue(description, size: UIDevice.isPhone ? 9 : 12, numberOfLines: 1, color: .themeDarkenPink, textAlignment: .center)
        iconImageView.image = image
        
        addInnerShadowImage()
        setupLayout()
    }
    
    private func setupLayout() {
        backgroundColor = .themePink
        addSubviews(iconImageView, countLabel, descriptionLabel)
        
        let maxWidth = frame.width / 3
        let maxInset: CGFloat = 20 / 1.3
        iconImageView.widthAnchor.constraint(equalToConstant: maxWidth).isActive = true
        iconImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, padding: UIEdgeInsets(top: 20, left: maxInset, bottom: 20, right: 0), size: CGSize(width: 0, height: 50))
        if UIDevice.isPhone {
        } else if UIDevice.isPad {
            
        }
        
        countLabel.anchor(leading: iconImageView.trailingAnchor, bottom: centerYAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: maxInset, bottom: 0, right: 10))
        
        descriptionLabel.anchor(top: centerYAnchor, leading: iconImageView.trailingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: maxInset, bottom: 0, right: 10))
        
        layer.masksToBounds = true
        layer.cornerRadius = 30
    }
    
    private func addInnerShadowImage() {
        let borderLayer = CALayer()
        let borderImage = #imageLiteral(resourceName: "rectangle").cgImage
        borderLayer.contents = borderImage
        borderLayer.frame = CGRect(origin: .zero, size: frame.size)
        layer.insertSublayer(borderLayer, below: layer)
    }
    
}
