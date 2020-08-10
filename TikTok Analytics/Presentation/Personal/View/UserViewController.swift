//
//  UserViewController.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 06.08.2020.
//

import UIKit
import RxSwift

class UserViewController: ViewController {
    
    convenience init(viewModel: UserViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    let scrollView = UIScrollView()
    
    let userImageView = UserImageView(image: UIImage())
    let loginLabel = Label()
    let bioLabel = Label()
    
    let topFollowingView = SquaredView()
    let topFollowersView = SquaredView()
    let topHeartsView = SquaredView()
    lazy var topCounterView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topFollowingView, topFollowersView, topHeartsView])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    let topCounterBorder = UIView()
    
    let detailsTitleLabel = Label()
    let detailsCollectionView = DetailsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let detailsSquaredView = SquaredFooterView()
    let detailsrBorder = UIView()
    
    let videoListTitleLabel = Label()
    
    let videoListCollectionView = VideoListCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activityIndicatorView.style = .large
        } else {
            activityIndicatorView.style = .whiteLarge
        }
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = .white
        
        return activityIndicatorView
    }()
    
    private var viewModel: UserViewModel!
    private var videoListViewModel: VideoListViewModel?
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        configureUserScreen()
        configureCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureGesture()
    }
    
}

extension UserViewController: UserScreenDelegate {
    private func setupLayout() {
        view.backgroundColor = .theme
        topCounterBorder.backgroundColor = .themeWhiteTransparent
        detailsrBorder.backgroundColor = .themeWhiteTransparent
        detailsCollectionView.backgroundColor = .clear
        videoListCollectionView.backgroundColor = .clear
        
        view.addSubview(scrollView)
        scrollView.addSubviews(userImageView, loginLabel, bioLabel, topCounterView, topCounterBorder, detailsTitleLabel, detailsCollectionView, detailsSquaredView)
        
        scrollView.fillSuperview()
        if UIDevice.isPhone {
            userImageView.anchor(top: scrollView.topAnchor, leading: view.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 48, bottom: 0, right: 0), size: CGSize(width: 80, height: 80))
            loginLabel.anchor(top: scrollView.topAnchor, leading: userImageView.trailingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 23, bottom: 0, right: 48))
            bioLabel.anchor(top: loginLabel.bottomAnchor, leading: loginLabel.leadingAnchor, trailing: loginLabel.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
            topCounterView.anchor(top: userImageView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 14, left: 48, bottom: 0, right: 48), size: CGSize(width: 0, height: 65))
            topCounterView.arrangedSubviews.forEach {
                $0.widthAnchor.constraint(equalToConstant: 65).isActive = true
            }
            
            topCounterBorder.anchor(top: topCounterView.bottomAnchor, leading: topCounterView.leadingAnchor, trailing: topCounterView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: -10, bottom: 0, right: -10), size: CGSize(width: 0, height: 2))
            
            detailsTitleLabel.anchor(top: topCounterBorder.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 34, left: 36, bottom: 0, right: 36))
            
            detailsCollectionView.anchor(top: detailsTitleLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 34, left: 28, bottom: 0, right: 28), size: CGSize(width: 0, height: 200))
            
            detailsSquaredView.anchor(top: detailsCollectionView.bottomAnchor, leading: detailsCollectionView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: detailsCollectionView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 90))
        } else if UIDevice.isPad {
            view.addSubview(activityIndicatorView)
            scrollView.addSubview(detailsrBorder)
            userImageView.anchor(top: scrollView.topAnchor, leading: view.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 105, bottom: 0, right: 0), size: CGSize(width: 192, height: 192))
            loginLabel.anchor(top: scrollView.topAnchor, leading: userImageView.trailingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 76, bottom: 0, right: 55))
            bioLabel.anchor(top: loginLabel.bottomAnchor, leading: loginLabel.leadingAnchor, trailing: loginLabel.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
            topCounterView.centerXAnchor.constraint(equalTo: topCounterBorder.centerXAnchor).isActive = true
            topCounterView.anchor(top: bioLabel.bottomAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 345, height: 65))
            topCounterView.arrangedSubviews.forEach {
                $0.widthAnchor.constraint(equalToConstant: 65).isActive = true
            }
            topCounterBorder.anchor(top: topCounterView.bottomAnchor, leading: bioLabel.leadingAnchor, trailing: bioLabel.trailingAnchor, padding: UIEdgeInsets(top: 35, left: -10, bottom: 0, right: -10), size: CGSize(width: 0, height: 2))
                
            detailsTitleLabel.anchor(top: topCounterBorder.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 50, left: 90, bottom: 0, right: 90))
                
            let wrapper = UIView()
            scrollView.addSubviews(wrapper, videoListTitleLabel, videoListCollectionView)
            wrapper.anchor(top: detailsTitleLabel.bottomAnchor, padding: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0), size: CGSize(width: 730, height: 200))
            wrapper.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                
            detailsCollectionView.anchor(top: wrapper.topAnchor, leading: wrapper.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 385, height: 200))
            detailsSquaredView.anchor(top: wrapper.topAnchor, leading: detailsCollectionView.trailingAnchor, bottom: wrapper.bottomAnchor, padding: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0), size: CGSize(width: 320, height: 200))
            scrollView.bringSubviewToFront(detailsSquaredView)
            
            detailsrBorder.isHidden = true
            detailsrBorder.anchor(top: wrapper.bottomAnchor, leading: wrapper.leadingAnchor, trailing: wrapper.trailingAnchor, padding: UIEdgeInsets(top: 35, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 2))
            
            videoListTitleLabel.anchor(top: detailsrBorder.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 50, left: 90, bottom: 0, right: 90))
            
            let width = (view.frame.width - 144 - 100) / 3
            let height = width * 1.6
            videoListCollectionView.anchor(top: videoListTitleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 50, left: 72, bottom: 0, right: 72), size: CGSize(width: 0, height: height))
            
            activityIndicatorView.topAnchor.constraint(equalTo: detailsrBorder.bottomAnchor, constant: 50).isActive = true
            activityIndicatorView.anchor(centerX: view.centerXAnchor)
        }
        
        view.layoutIfNeeded()
    }
    
    private func bindViewModel() {
        viewModel.output.userImage
            .subscribe { [weak self] (event) in
                guard let `self` = self else { return }
                guard let image = event.element else { return }
                self.setUserImage(image: image)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.userInfo
            .subscribe { [weak self] event in
                guard let `self` = self else { return }
                guard let data = event.element else { return }
                self.setUserData(data)
                self.bindVideoListViewModel()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindVideoListViewModel() {
        videoListViewModel?
            .output
            .videos
            .skip(1)
            .subscribe { [weak self] event in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    self.detailsrBorder.isHidden = false
                    self.videoListTitleLabel.setValue("Recent Videos", size: 14, isScalable: true, numberOfLines: 1)
                    self.videoListCollectionView.reloadData()
                }
            }
            .disposed(by: disposeBag)
        
        videoListViewModel?.output.isLoading
            .subscribe { [weak self] event in
                guard let `self` = self else { return }
                guard let isLoading = event.element else { return }
                DispatchQueue.main.async {
                    if isLoading {
                        self.activityIndicatorView.startAnimating()
                    } else {
                        self.activityIndicatorView.stopAnimating()
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setUserImage(image: UIImage) {
        userImageView.image = image
        userImageView.bordering()
    }
    
    private func setUserData(_ userData: UserViewModel.Model) {
        videoListViewModel = VideoListViewModel(userData: userData)
        
        loginLabel.setValue(userData.login, size: UIDevice.isPhone ? 14 : 24, numberOfLines: 1)
        bioLabel.setValue(userData.bio, size: UIDevice.isPhone ? 12 : 18, numberOfLines: 3)
        
        topFollowingView.setValue(count: userData.following, description: "Following")
        topFollowersView.setValue(count: userData.followers, description: "Followers")
        topHeartsView.setValue(count: userData.hearts, description: "Hearts")
        
        detailsTitleLabel.setValue("Current follow details", size: 14, isScalable: true, numberOfLines: 1)
        
        detailsSquaredView.setValue(image: #imageLiteral(resourceName: "video-camera"), count: userData.videosCount, description: "Videos", actionTitle: "Show Analytics", actionImage: #imageLiteral(resourceName: "arrow"), suareCellSize: CGSize(width: detailsCollectionView.frame.width / 2 - 10, height: UIDevice.isPhone ? 90 : 200))
    }
    
    private func configureCollectionView() {
        detailsCollectionView.register(SquaredCollectionViewCell.self, forCellWithReuseIdentifier: SquaredCollectionViewCell.reuseIdentifier)
        detailsCollectionView.delegate = self
        detailsCollectionView.dataSource = self
        detailsCollectionView.collectionViewLayout = {
            let collectionViewLayout = UICollectionViewFlowLayout()
            collectionViewLayout.itemSize = CGSize(width: detailsCollectionView.frame.width / 2 - 10, height: 90)
            collectionViewLayout.minimumInteritemSpacing = 20
            collectionViewLayout.minimumLineSpacing = 20
            
            return collectionViewLayout
        }()
        
        videoListCollectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: VideoCollectionViewCell.reuseIdentifier)
        videoListCollectionView.delegate = self
        videoListCollectionView.dataSource = self
        videoListCollectionView.collectionViewLayout = {
            let collectionViewLayout = UICollectionViewFlowLayout()
            collectionViewLayout.scrollDirection = .horizontal
            collectionViewLayout.minimumInteritemSpacing = 0
            collectionViewLayout.minimumLineSpacing = 50
            
            if UIDevice.isPhone {
                let width = videoListCollectionView.frame.width / 2 - 20
                let height = width * 1.6
                collectionViewLayout.itemSize = CGSize(width: width, height: height)
                let inset = (videoListCollectionView.frame.width - 780 - 100) / 2
                collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: 0)
            } else if UIDevice.isPad {
                let width = (videoListCollectionView.frame.width - 100) / 3
                let height = width * 1.6
                collectionViewLayout.itemSize = CGSize(width: width, height: height)
                collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            
            return collectionViewLayout
        }()
    }
    
    private func configureGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onShowAnalyticsViewTap))
        detailsSquaredView.isUserInteractionEnabled = true
        detailsSquaredView.addGestureRecognizer(tap)
    }
    
    func configureUserScreen() {
        let logoutBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "logout"), style: .plain, target: self, action: #selector(onLogoutButtonClick))
        navigationItem.rightBarButtonItem = logoutBarButtonItem
        navigationItem.hidesBackButton = true
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc private func onLogoutButtonClick(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func onShowAnalyticsViewTap(_ sender: UITapGestureRecognizer!) {
        guard let viewModel = videoListViewModel else { return }
        let vc = VideoListViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension UserViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView is DetailsCollectionView {
            return 4
        } else if let count =  videoListViewModel?.output.videos.value.count,
            count >= 3 {
            return 3
        } else {
            return videoListViewModel?.output.videos.value.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView is DetailsCollectionView {
            let cell = detailsCollectionView.dequeueReusableCell(withReuseIdentifier: SquaredCollectionViewCell.reuseIdentifier, for: indexPath) as! SquaredCollectionViewCell
            
            switch indexPath.item {
                case 0:
                    cell.setValue(count: viewModel.output.userInfo.value.followers, description: "Followers", image: #imageLiteral(resourceName: "crowd"))
                case 1:
                    cell.setValue(count: viewModel.output.userInfo.value.gained, description: "Gained", image: #imageLiteral(resourceName: "person-2"))
                case 2:
                    cell.setValue(count: viewModel.output.userInfo.value.hearts, description: "Likes", image: #imageLiteral(resourceName: "hearts"))
                case 3:
                    cell.setValue(count: viewModel.output.userInfo.value.lost, description: "Lost", image: #imageLiteral(resourceName: "person-1"))
                default: ()
            }
            
            return cell
        } else {
            let cell = videoListCollectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.reuseIdentifier, for: indexPath) as! VideoCollectionViewCell
            if let data = videoListViewModel?.output.videos.value[indexPath.item] {
                cell.setValue(coverUrlString: data.cover, views: String(data.plays), hearts: String(data.likes), links: String(data.shares), comments: String(data.comments))
            }
            return cell
        }
    }
    
}
