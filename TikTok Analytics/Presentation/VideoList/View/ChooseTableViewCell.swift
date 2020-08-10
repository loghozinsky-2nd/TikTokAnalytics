//
//  ChooseTableViewCell.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 08.08.2020.
//

import UIKit

class ChooseTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: self)
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = .clear
            selector.image = isSelected ? #imageLiteral(resourceName: "selector-active") : #imageLiteral(resourceName: "selector")
        }
    }
    
    let titleLabel = Label()
    let selector = UIImageView()
    
    func setValue(title: String) {
        titleLabel.setValue(title, size: 14, color: .black)
        
        selectionStyle = .none
        setupLayout()
    }
    
    private func setupLayout() {
        backgroundColor = .white
        
        addSubviews(selector, titleLabel)
        
        selector.anchor(leading: leadingAnchor, padding: UIEdgeInsets(top: 12, left: 35, bottom: 12, right: 0), size: CGSize(width: 17, height: 17))
        selector.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        titleLabel.anchor(leading: selector.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), size: CGSize(width: 0, height: 17))
        titleLabel.centerYAnchor.constraint(equalTo: selector.centerYAnchor).isActive = true
    }
    
}
