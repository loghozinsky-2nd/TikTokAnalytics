//
//  OnboardingCollectionViewCell.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 11.08.2020.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    let backgroundContentView = UIView()
    
    let userImageView = UserImageView(image: UIImage())
    let loginLabel = Label()
    let bioLabel = Label()
    
//    let button = 
    
    func setValue(userData: UserViewModel.Model) {
        contentView.addSubviews(backgroundContentView, userImageView, loginLabel, bioLabel)
    }
    
}
