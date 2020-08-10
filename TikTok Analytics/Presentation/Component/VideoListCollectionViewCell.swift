//
//  VideoListCollectionViewCell.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 08.08.2020.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: self)
    
    let imageView = ImageView(image: UIImage())
    
    let viewsBackground = UIView()
    let viewsIconImageView = ImageView(image: #imageLiteral(resourceName: "icon-seen"))
    let viewsCountLabel = Label()
    
    let heartsBackground = UIView()
    let heartsIconImageView = ImageView(image: #imageLiteral(resourceName: "icon-heart"))
    let heartsCountLabel = Label()
    
    let linksBackground = UIView()
    let linksIconImageView = ImageView(image: #imageLiteral(resourceName: "icon-link"))
    let linksCountLabel = Label()
    
    let commentsBackground = UIView()
    let commentsIconImageView = ImageView(image: #imageLiteral(resourceName: "icon-comment"))
    let commentsCountLabel = Label()
    
    func setValue(views: String, hearts: String, links: String, comments: String, image: UIImage) {
        imageView.image = image
        
        setupLayout()
    }
    
    private func setupLayout() {
        backgroundColor = .themePink
        
        addSubviews(imageView, viewsBackground, heartsBackground, linksBackground, commentsBackground)
        viewsBackground.addSubviews(viewsIconImageView, viewsCountLabel)
        heartsBackground.addSubviews(heartsIconImageView, heartsCountLabel)
        linksBackground.addSubviews(linksIconImageView, linksCountLabel)
        commentsBackground.addSubviews(commentsIconImageView, commentsCountLabel)
        
        imageView.fillSuperview()
        
        commentsBackground.anchor(leading: leadingAnchor, bottom: bottomAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 0), size: CGSize(width: 30, height: 30))
        
        linksBackground.anchor(leading: leadingAnchor, bottom: commentsBackground.topAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 0), size: CGSize(width: 30, height: 30))
        
        heartsBackground.anchor(leading: leadingAnchor, bottom: linksBackground.topAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 0), size: CGSize(width: 30, height: 30))
        
        viewsBackground.anchor(leading: leadingAnchor, bottom: heartsBackground.topAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 0), size: CGSize(width: 30, height: 30))
        
        layer.masksToBounds = true
        layer.cornerRadius = 30
    }
    
    private func formatCountValue(countLabel: String) -> String {
        guard let count = Int(countLabel) else { return "0" }
        switch count {
            case 0 ..< 1_000:
                return String(count)
            case 1_000 ..< 100_000:
                let countOfDigits = Int(countLabel.count - (countLabel.count - 4))
                var cuttedString = String(countLabel.prefix(countOfDigits))
                cuttedString.insert(".", at: .init(utf16Offset: countOfDigits - 2, in: cuttedString))
                if cuttedString.last == "0" {
                    return cuttedString.dropLast(1) + "K"
                }
                return String(cuttedString) + "K"
            case 100_000 ..< 1_000_000:
                let countOfDigits = Int(countLabel.count - (countLabel.count - 3))
                let cuttedString = String(countLabel.prefix(countOfDigits))
                if cuttedString.last == "0" {
                    return cuttedString.dropLast(2) + "K"
                }
                return String(cuttedString) + "K"
            default:
                let countOfDigits = Int(countLabel.count - (countLabel.count - 2))
                var cuttedString = String(countLabel.prefix(countOfDigits))
                cuttedString.insert(".", at: .init(utf16Offset: countOfDigits - 1, in: cuttedString))
                if cuttedString.last == "0" {
                    return cuttedString.dropLast(2) + "M"
                }
                return String(cuttedString) + "M"
        }
    }
    
}
