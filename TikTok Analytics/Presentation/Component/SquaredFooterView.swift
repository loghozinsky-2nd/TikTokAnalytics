//
//  SquaredFooterView.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 07.08.2020.
//

import UIKit

class SquaredFooterView: UIView, CountValueFormatter {
    
    let containerView = UIView()
    let countLabel = Label()
    let descriptionLabel = Label()
    let iconImageView = ImageView(image: UIImage())
    
    let actionTitleLabel = Label()
    let actionImageView = ImageView(image: UIImage())
    
    var size: CGSize!
    
    func setValue(image: UIImage, count: String, description: String, actionTitle: String, actionImage: UIImage, suareCellSize: CGSize) {
        size = suareCellSize
        countLabel.setValue(formatCountValue(countLabel: count), size: UIDevice.isPhone ? 14 : 18, numberOfLines: 1, color: .themeDarkenPink, textAlignment: .center)
        descriptionLabel.setValue(description, size: UIDevice.isPhone ? 9 : 12, numberOfLines: 1, color: .themeDarkenPink, textAlignment: .center)
        iconImageView.image = image
        actionTitleLabel.setValue(actionTitle, size: UIDevice.isPhone ? 14 : 24, numberOfLines: 1, color: .themeDarkenPink, textAlignment: .right)
        actionImageView.image = actionImage
        
        addInnerShadowImage()
        setupLayout()
    }
    
    private func setupLayout() {
        backgroundColor = .themePink
        addSubviews(containerView, actionTitleLabel, actionImageView)
        containerView.addSubviews(iconImageView, countLabel, descriptionLabel)
        
        let maxWidth = size.width / 3
        let maxInset: CGFloat = 20 / 1.3
        if UIDevice.isPhone {
            containerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, size: CGSize(width: size.width, height: 0))
            iconImageView.widthAnchor.constraint(equalToConstant: maxWidth).isActive = true
            iconImageView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, padding: UIEdgeInsets(top: 20, left: maxInset, bottom: 20, right: 0), size: CGSize(width: 0, height: 50))
            
            countLabel.anchor(leading: iconImageView.trailingAnchor, bottom: centerYAnchor, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: maxInset, bottom: 4, right: 10))
            
            
            descriptionLabel.anchor(top: containerView.centerYAnchor, leading: iconImageView.trailingAnchor, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: maxInset, bottom: 0, right: 10))
            
            actionTitleLabel.anchor(leading: containerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: maxInset, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
            actionTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            actionImageView.anchor(leading: actionTitleLabel.trailingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5), size: CGSize(width: 34, height: 34))
            actionImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        } else if UIDevice.isPad {
            containerView.anchor(top: topAnchor, bottom: centerYAnchor, padding: UIEdgeInsets(top: 33, left: 0, bottom: 0, right: 0))
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            iconImageView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, size: CGSize(width: 50, height: 0))
            
            countLabel.anchor(leading: iconImageView.trailingAnchor, bottom: iconImageView.centerYAnchor, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: maxInset, bottom: 0, right: 10))
            descriptionLabel.anchor(top: iconImageView.centerYAnchor, leading: iconImageView.trailingAnchor, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: maxInset, bottom: 0, right: 10))
            
            actionTitleLabel.anchor(leading: leadingAnchor, bottom: bottomAnchor, padding: UIEdgeInsets(top: 0, left: 40, bottom: 40, right: 0))
            
            actionImageView.anchor(trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 28), size: CGSize(width: 34, height: 34))
            actionImageView.centerYAnchor.constraint(equalTo: actionTitleLabel.centerYAnchor).isActive = true
        }
        
        layer.masksToBounds = true
        layer.cornerRadius = 30
    }
    
    private func addInnerShadowImage() {
        let layer0 = CAGradientLayer()
        
        layer0.colors = [
            UIColor(red: 0.924, green: 0.858, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.922, green: 0.851, blue: 1, alpha: 1).cgColor,
            UIColor.theme.cgColor
        ]
        
        layer0.locations = [0, 0.85, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.06, b: 0, c: 0, d: 13.31, tx: 0, ty: -6.16))
        
        layer0.bounds = bounds.insetBy(dx: -0.5 * bounds.size.width, dy: -0.5 * bounds.size.height)
        
        layer0.position = center
        layer0.cornerRadius = 30
        
        layer.addSublayer(layer0)
    }
    
}
