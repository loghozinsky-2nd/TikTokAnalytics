//
//  PopupViewController.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 08.08.2020.
//

import UIKit
import RxSwift

protocol SortByPopupDelegate: class {
    func choose(sortType type: VideoListViewModel.SortBy)
}

struct PopupViewModel {
    var sortBy: VideoListViewModel.SortBy!
    let data = VideoListViewModel.SortBy.keys
}

class PopupViewController: UIViewController {
    
    let button = GradientButton(withText: "Apply")
    
    let wrapper = UIView()
    let tableView = UITableView(frame: .zero, style: .plain)
    
    let blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: effect)
        visualEffectView.frame = UIScreen.main.bounds
        visualEffectView.layer.opacity = 0

        return visualEffectView
    }()
    
    private var viewModel = PopupViewModel()
    weak var delegate: SortByPopupDelegate?
    
    convenience init(_ delegate: SortByPopupDelegate, sortType type: VideoListViewModel.SortBy) {
        self.init()
        
        self.delegate = delegate
        self.viewModel.sortBy = type
    }
    
    override func loadView() {
        super.loadView()
        
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        configureTableView()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        wrapper.center = CGPoint(x: view.center.x, y: view.frame.size.height)
        button.center = CGPoint(x: view.center.x, y: view.frame.size.height)
        UIView.animate(withDuration: 0.25) {
            self.blurView.alpha = 0.85
            self.button.layer.opacity = 1
            self.view.layoutIfNeeded()
        }
    }
    
}

extension PopupViewController {
    private func setupLayout() {
        wrapper.backgroundColor = .white
        
        view.addSubviews(blurView, wrapper, button)
        wrapper.addSubview(tableView)
        
        wrapper.clipsToBounds = true
        wrapper.layer.cornerRadius = 7
        
        if UIDevice.isPhone {
            button.anchor(leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 32, bottom: 50, right: 32), size: CGSize(width: 0, height: 36))
            wrapper.anchor(leading: view.leadingAnchor, bottom: button.topAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 32, bottom: 35, right: 32), size: CGSize(width: 0, height: 228))
            tableView.fillSuperview(padding: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 14))
        } else if UIDevice.isPad {
            button.anchor(bottom: view.bottomAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0), size: CGSize(width: 310, height: 36))
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            wrapper.anchor(leading: button.leadingAnchor, bottom: button.topAnchor, trailing: button.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 35, right: 0), size: CGSize(width: 0, height: 228))
            tableView.fillSuperview(padding: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 14))
        }
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(tap)
        
        button.addTarget(self, action: #selector(chooseModelWithIndex), for: .touchUpInside)
    }
    
    private func configureTableView() {
        tableView.register(ChooseTableViewCell.self, forCellReuseIdentifier: ChooseTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.isScrollEnabled = false
        tableView.rowHeight = 44
    }
    
    @objc private func chooseModelWithIndex(_ sender: UIButton) {
        let typeRawValue = viewModel.data[sender.tag].lowercased()
        if let type = VideoListViewModel.SortBy(rawValue: typeRawValue) {
            delegate?.choose(sortType: type)
        }
        
        dismiss(animated: true)
    }
    
    @objc private func dismissPopup() {
        dismiss(animated: true)
    }
}

extension PopupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChooseTableViewCell.reuseIdentifier) as! ChooseTableViewCell
        
        let type = viewModel.data[indexPath.row]
        if type == viewModel.sortBy.rawValue.capitalized {
            button.tag = indexPath.item
            
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        }
            
        cell.setValue(title: type)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.row == 4 ? 46 : 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        button.tag = indexPath.item
        
        if let cell = tableView.cellForRow(at: indexPath) as? ChooseTableViewCell  {
            cell.isSelected = true
        }
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if let cell = tableView.cellForRow(at: indexPath) as? ChooseTableViewCell  {
            cell.isSelected = false
        }
        
        return indexPath
    }

}
