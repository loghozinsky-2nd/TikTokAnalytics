//
//  NavigationController.swift
//  TikTok Analytics
//
//  Created by Aleksander Logozinsky on 05.08.2020.
//

import UIKit

protocol AuthScreenDelegate: class {
    func configureAuthScreen()
}

protocol UserScreenDelegate: class {
    func configureUserScreen()
}

protocol VideoListScreenDelegate: class {
    func configureVideoListScreen()
}

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupNavigationBar() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .theme
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            
            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
        
        navigationBar.isHidden = false
        navigationBar.isTranslucent = false
        navigationBar.backgroundColor = .theme
        navigationBar.tintColor = .white
        
        // This element should overlap default NavBar's border
        let border = UIView()
        navigationBar.addSubviews(border)
        border.backgroundColor = .theme
        border.anchor(top: navigationBar.bottomAnchor, leading: navigationBar.leadingAnchor, trailing: navigationBar.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 1))
    }
    
}
