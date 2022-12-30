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
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let trendingCoordinator = TrendingCoordinator(navigationController: navigationController)
        self.Add(coordinator: trendingCoordinator)
        trendingCoordinator.start()
        window.rootViewController =  navigationController
        window.makeKeyAndVisible()
    }
    
}
