//
//  NavigationController.swift
//  TikTok Analytics
//
//  Created by Aleksander Logozinsky on 05.08.2020.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
    }
    
    private func setupNavigation() {
        navigationBar.isHidden = true
    }
    
}
