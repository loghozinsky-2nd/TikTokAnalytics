//
//  VideoCollectionViewCell.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 08.08.2020.
//

import UIKit

protocol LoadImageDelegate: class {
    func postImage(_ image: UIImage)
}

class VideoViewModel {
    
    var image: UIImage?
    private weak var delegate: LoadImageDelegate?
    
    init(_ delegate: LoadImageDelegate, imageUrl: String) {
        self.delegate = delegate
        fetchImage(withUrlString: imageUrl)
    }
    
    private func fetchImage(withUrlString urlString: String) {
        APIService.shared.getImage(withUrlString: urlString) { (data) in
            if let image = UIImage(data: data) {
                self.delegate?.postImage(image)
            }
        }
    }
    
}

class VideoCollectionViewCell: UICollectionViewCell, CountValueFormatter, LoadImageDelegate {
    
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
    
    private var viewModel: VideoViewModel?
    
    func setValue(coverUrlString: String, views: String, hearts: String, links: String, comments: String) {
        if viewModel == nil {
            viewModel = VideoViewModel(self, imageUrl: coverUrlString)
        }
        
        viewsCountLabel.setValue(formatCountValue(countLabel: views), size: 5, numberOfLines: 1, textAlignment: .center)
        heartsCountLabel.setValue(formatCountValue(countLabel: hearts), size: 5, numberOfLines: 1, textAlignment: .center)
        linksCountLabel.setValue(formatCountValue(countLabel: links), size: 5, numberOfLines: 1, textAlignment: .center)
        commentsCountLabel.setValue(formatCountValue(countLabel: comments), size: 5, numberOfLines: 1, textAlignment: .center)
        
        setupLayout()
    }
    
    private func setupLayout() {
        backgroundColor = .themeWhiteTransparent
        viewsBackground.backgroundColor = .theme
        heartsBackground.backgroundColor = .theme
        linksBackground.backgroundColor = .theme
        commentsBackground.backgroundColor = .theme
        
        addSubviews(imageView, viewsBackground, heartsBackground, linksBackground, commentsBackground)
        viewsBackground.addSubviews(viewsIconImageView, viewsCountLabel)
        heartsBackground.addSubviews(heartsIconImageView, heartsCountLabel)
        linksBackground.addSubviews(linksIconImageView, linksCountLabel)
        commentsBackground.addSubviews(commentsIconImageView, commentsCountLabel)
        
        imageView.fillSuperview()
        
        commentsBackground.anchor(leading: leadingAnchor, bottom: bottomAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0), size: CGSize(width: 30, height: 30))
        commentsIconImageView.anchor(top: commentsBackground.topAnchor, padding: UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 10), size: CGSize(width: 10, height: 6))
        commentsIconImageView.centerXAnchor.constraint(equalTo: commentsBackground.centerXAnchor).isActive = true
        commentsCountLabel.anchor(top: commentsIconImageView.bottomAnchor, leading: commentsBackground.leadingAnchor, trailing: commentsBackground.trailingAnchor, padding: UIEdgeInsets(top: 3, left: 10, bottom: 0, right: 10), size: CGSize(width: 10, height: 6))
        
        linksBackground.anchor(leading: leadingAnchor, bottom: commentsBackground.topAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 0), size: CGSize(width: 30, height: 30))
        linksIconImageView.anchor(top: linksBackground.topAnchor, leading: linksBackground.leadingAnchor, trailing: linksBackground.trailingAnchor, padding: UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 10), size: CGSize(width: 10, height: 6))
        linksIconImageView.centerXAnchor.constraint(equalTo: linksBackground.centerXAnchor).isActive = true
        linksCountLabel.anchor(top: linksIconImageView.bottomAnchor, leading: linksBackground.leadingAnchor, trailing: linksBackground.trailingAnchor, padding: UIEdgeInsets(top: 3, left: 10, bottom: 0, right: 10), size: CGSize(width: 10, height: 6))
        
        heartsBackground.anchor(leading: leadingAnchor, bottom: linksBackground.topAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 0), size: CGSize(width: 30, height: 30))
        heartsIconImageView.anchor(top: heartsBackground.topAnchor, leading: heartsBackground.leadingAnchor, trailing: heartsBackground.trailingAnchor, padding: UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 10), size: CGSize(width: 10, height: 6))
        heartsIconImageView.centerXAnchor.constraint(equalTo: heartsBackground.centerXAnchor).isActive = true
        heartsCountLabel.anchor(top: heartsIconImageView.bottomAnchor, leading: heartsBackground.leadingAnchor, trailing: heartsBackground.trailingAnchor, padding: UIEdgeInsets(top: 3, left: 10, bottom: 0, right: 10), size: CGSize(width: 10, height: 6))
        
        viewsBackground.anchor(leading: leadingAnchor, bottom: heartsBackground.topAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 0), size: CGSize(width: 30, height: 30))
        viewsIconImageView.anchor(top: viewsBackground.topAnchor, padding: UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 10), size: CGSize(width: 10, height: 6))
        viewsIconImageView.centerXAnchor.constraint(equalTo: viewsBackground.centerXAnchor).isActive = true
        viewsCountLabel.anchor(top: viewsIconImageView.bottomAnchor, leading: viewsBackground.leadingAnchor, trailing: viewsBackground.trailingAnchor, padding: UIEdgeInsets(top: 3, left: 10, bottom: 0, right: 10), size: CGSize(width: 10, height: 6))
        
        
        viewsBackground.layer.masksToBounds = true
        viewsBackground.layer.cornerRadius = 15
        heartsBackground.layer.masksToBounds = true
        heartsBackground.layer.cornerRadius = 15
        linksBackground.layer.masksToBounds = true
        linksBackground.layer.cornerRadius = 15
        commentsBackground.layer.masksToBounds = true
        commentsBackground.layer.cornerRadius = 15
        
        layer.masksToBounds = true
        layer.cornerRadius = 30
        layoutIfNeeded()
    }
    
    func postImage(_ image: UIImage) {
        imageView.image = image
    }
    
}
