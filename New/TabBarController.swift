//
//  TabBarController.swift
//  New
//
//  Created by Dmytro Yurchenko on 21.03.2023.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    static let shared = TabBarController()
    
    enum TabBarItems {
        case exchange
        case profile
    }
    
    lazy var profileController: UINavigationController = {
        let navigationViewController = UINavigationController(rootViewController: LoginViewController())
        navigationViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        return navigationViewController
    }()
    
    lazy var weatherController: UINavigationController = {
        let navigationViewController = UINavigationController(rootViewController: WeatherDataTableViewController())
        navigationViewController.tabBarItem = UITabBarItem(title: "Weather", image: UIImage(systemName: "cloud"), selectedImage: UIImage(systemName: "cloud.fill"))
        
        return navigationViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        
        self.viewControllers = [weatherController, profileController]
    }
    
}

