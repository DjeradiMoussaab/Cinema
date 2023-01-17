//
//  AppCoordinator.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 28/12/2022.
//

import Foundation
import UIKit


// MARK: The App Coordinator

class AppCoordinator: BaseCoordinator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController = {
        return UINavigationController()
    }()
    var rootViewController: UIViewController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        rootViewController = UITabBarController()
        let tabCoordinator = TabCoordinator(tabBarController: rootViewController as! UITabBarController)
        self.Add(coordinator: tabCoordinator)
        tabCoordinator.start()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
}
