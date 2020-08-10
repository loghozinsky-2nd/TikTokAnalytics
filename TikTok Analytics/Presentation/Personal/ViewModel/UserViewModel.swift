//
//  UserViewModel.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 07.08.2020.
//

import UIKit
import RxSwift
import RxCocoa

class UserViewModel {
    
    struct Model {
        let id: Int
        let login: String
        let bio: String
        let following: String
        let followers: String
        let hearts: String
        let gained: String
        let lost: String
        let videosCount: String
        
        init(userData: UserData) {
            id = userData.id
            login = userData.login
            bio = userData.bio ?? ""
            following = String(userData.following)
            followers = String(userData.followers)
            hearts = String(userData.likes)
            gained = String(userData.followersGained)
            lost = String(userData.followersLost)
            videosCount = String(userData.videos)
        }
    }
    
    private var userImage: BehaviorRelay<UIImage>
    private var userInfo: BehaviorRelay<Model>
    
    private var input: UserData
    lazy var output = (userImage: userImage, userInfo: userInfo)
    
    init(userData: UserData) {
        self.input = userData
        
        self.userImage = BehaviorRelay(value: UIImage())
        self.userInfo = BehaviorRelay(value: Model(userData: userData))
        
        process()
    }
    
    private func process() {
        fetchUserImage()
    }
    
    private func fetchUserImage() {
        if let urlString = input.avatar {
            APIService.shared.getImage(withUrlString: urlString) { [weak self] (response) in
                guard let `self` = self else { return }
                guard let image = UIImage(data: response) else { return }
                self.userImage.accept(image)
            }
        } else {
            print("error")
        }
    }
    
}
