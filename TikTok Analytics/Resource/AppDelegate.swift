//
//  AppDelegate.swift
//  TikTok Analytics
//
//  Created by Aleksander Logozinsky on 05.08.2020.
//
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = AuthViewController()
        window?.rootViewController = NavigationController(rootViewController: rootViewController)
        window?.makeKeyAndVisible()
        
        return true
    }
    
}

