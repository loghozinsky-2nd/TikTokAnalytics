//
//  VideoListViewController.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 07.08.2020.
//

import UIKit
import RxSwift

class VideoListViewController: ViewController {
    
    let popupView = UIViewController()
    
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
    
    let contentTitleLabel = Label()
    
    let collectionView = VideoListCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
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
    
    private var viewModel: VideoListViewModel!
    private let disposeBag = DisposeBag()
    
    convenience init(viewModel: VideoListViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func loadView() {
        super.loadView()
        
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        configureVideoListScreen()
        configureCollectionView()
        setUserStats()
    }
    
}

extension VideoListViewController: VideoListScreenDelegate, SortByPopupDelegate {
    func configureVideoListScreen() {
        navigationController?.isNavigationBarHidden = false
        let logoutBarButtonItem = UIBarButtonItem(title: "Sort by", style: .plain, target: self, action: #selector(onSortButtonClick))
        navigationItem.rightBarButtonItem = logoutBarButtonItem
        navigationItem.hidesBackButton = false
        
        if UIDevice.isPhone {
            title = "Top Videos"
        }
    }
    
    func choose(sortType type: VideoListViewModel.SortBy) {
        viewModel.output.sortBy.accept(type)
    }
    
    private func setupLayout() {
        view.backgroundColor = .theme
        topCounterBorder.backgroundColor = .themeWhiteTransparent
        collectionView.backgroundColor = .clear
        
        if UIDevice.isPhone {
            view.addSubviews(collectionView, activityIndicatorView)
            
            collectionView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 36, bottom: 0, right: 36))
            
            activityIndicatorView.anchor(centerY: collectionView.centerYAnchor, centerX: view.centerXAnchor)
        } else if UIDevice.isPad {
            view.addSubviews(topCounterView, topCounterBorder, contentTitleLabel, collectionView, activityIndicatorView)
            topCounterView.anchor(top: view.topAnchor, size: CGSize(width: 345, height: 65))
            topCounterView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            topCounterView.arrangedSubviews.forEach {
                $0.widthAnchor.constraint(equalToConstant: 65).isActive = true
            }
            topCounterBorder.anchor(top: topCounterView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 30, left: 138, bottom: 0, right: 138), size: CGSize(width: 0, height: 2))
            
            contentTitleLabel.anchor(top: topCounterBorder.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0))
            
            collectionView.anchor(top: contentTitleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 72, bottom: 0, right: 72))
            
            activityIndicatorView.anchor(centerY: collectionView.centerYAnchor, centerX: view.centerXAnchor)
        }
        
        view.layoutIfNeeded()
    }
    
    private func bindViewModel() {
        viewModel.output.videos
            .subscribe { [weak self] event in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.output.isLoading
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
    
    private func showAlert() {
        let popup = PopupViewController(self, sortType: viewModel.output.sortBy.value)
        popup.modalPresentationStyle = .overCurrentContext
        popup.modalTransitionStyle = .crossDissolve
        present(popup, animated: true, completion: nil)
    }
    
    private func configureCollectionView() {
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: SquaredCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.collectionViewLayout = {
            let collectionViewLayout = UICollectionViewFlowLayout()
            collectionViewLayout.minimumInteritemSpacing = 20
            collectionViewLayout.minimumLineSpacing = 40
            collectionViewLayout.sectionInset = UIEdgeInsets(top: UIDevice.isPhone ? 28 : 40, left: 0, bottom: 28, right: 0)
            
            if UIDevice.isPhone {
                let width = collectionView.frame.width / 2 - 20
                let height = width * 1.6
                collectionViewLayout.itemSize = CGSize(width: width, height: height)
            } else if UIDevice.isPad {
                let width = collectionView.frame.width / 3 - 20
                let height = width * 1.6
                collectionViewLayout.itemSize = CGSize(width: width, height: height)
            }
            
            return collectionViewLayout
        }()
    }
    
    private func setUserStats() {
        contentTitleLabel.setValue("Top Videos", size: 24, numberOfLines: 1, textAlignment: .center)
        topFollowingView.setValue(count: viewModel.output.userStats.following, description: "Following")
        topFollowersView.setValue(count: viewModel.output.userStats.followers, description: "Followers")
        topHeartsView.setValue(count: viewModel.output.userStats.hearts, description: "Hearts")
    }
    
    @objc private func onSortButtonClick(_ sender: UIBarButtonItem) {
        showAlert()
    }
}

extension VideoListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.output.videos.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.reuseIdentifier, for: indexPath) as! VideoCollectionViewCell
        let data = viewModel.output.videos.value[indexPath.item]
        cell.setValue(coverUrlString: data.cover, views: String(data.plays), hearts: String(data.likes), links: String(data.shares), comments: String(data.comments))
        return cell
    }
}
