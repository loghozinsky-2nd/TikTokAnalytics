//
//  VideoListViewModel.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 07.08.2020.
//

import UIKit
import RxSwift
import RxCocoa

class VideoListViewModel {
    
    enum SortBy: String {
        case date
        case views
        case likes
        case comments
        case shares
        
        static var keys: [String] {
                [
                    VideoListViewModel.SortBy.date.rawValue.capitalized,
                    VideoListViewModel.SortBy.views.rawValue.capitalized,
                    VideoListViewModel.SortBy.likes.rawValue.capitalized,
                    VideoListViewModel.SortBy.comments.rawValue.capitalized,
                    VideoListViewModel.SortBy.shares.rawValue.capitalized
                ]
        }
    }
    
    struct Model {
        let id: Int
        let following: String
        let followers: String
        let hearts: String
        
        init(userData: UserViewModel.Model) {
            id = userData.id
            following = String(userData.following)
            followers = String(userData.followers)
            hearts = String(userData.hearts)
        }
    }
    
    private var videos: BehaviorRelay<[Video]>
    private var isLoading: BehaviorRelay<Bool>
    private var index: Int
    private var userStats: Model
    private var sortBy: BehaviorRelay<SortBy>
    
    lazy var output = (videos: videos, isLoading: isLoading, lastIndex: index, userStats: userStats, sortBy: sortBy)
    
    let disposeBag = DisposeBag()
    
    init(userData: UserViewModel.Model) {
        self.videos = BehaviorRelay(value: [])
        self.isLoading = BehaviorRelay(value: false)
        self.index = 0
        self.userStats = Model(userData: userData)
        self.sortBy = BehaviorRelay(value: .date)

        process()
    }
    
    private func process() {
        fetch()
        
        sortBy
            .subscribe { [weak self] event in
                guard let `self` = self else { return }
                guard let type = event.element else { return }
                self.sort(by: type)
            }
            .disposed(by: disposeBag)
    }
    
    func fetch() {
        isLoading.accept(true)
        APIService.shared.getVideoList(userId: userStats.id) { [weak self] (response, error) in
            guard let `self` = self else { return }
            self.isLoading.accept(false)
            
            guard let videos = response?.data else { return }
            self.videos.accept(videos)
        }
    }
    
    func sort(by type: SortBy) {
        let arr: [Video] = videos.value.sorted { (lhs, rhs) -> Bool in
            switch type {
                case .date: return lhs.createdAt > rhs.createdAt
                case .views: return lhs.plays > rhs.plays
                case .likes: return lhs.likes > rhs.likes
                case .comments: return lhs.comments > rhs.comments
                case .shares: return lhs.shares > rhs.shares
            }
        }
        
        videos.accept(arr)
    }
    
}
