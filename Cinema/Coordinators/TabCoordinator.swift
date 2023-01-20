//
//  TabCoordinator.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 17/1/2023.
//

import Foundation
import UIKit

// MARK: The Tab Bar Coordinator

class TabCoordinator: BaseCoordinator {
    
    var tabBarController: UITabBarController
    
    var trendingCoordinator: TrendingCoordinator
    var searchCoordinator: SearchCoordinator
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        
        trendingCoordinator = TrendingCoordinator(navigationController: UINavigationController())
        searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
        
    }
    
    override func start() {
    
        var controllers: [UIViewController] = []
        
        trendingCoordinator.start()
        searchCoordinator.start()
        
        let trendingController = trendingCoordinator.navigationController!
        trendingController.tabBarItem = UITabBarItem(title: Tabs.trending.rawValue, image: UIImage.init(systemName: "film"), selectedImage: UIImage.init(systemName: "film.fill"))
        
        let searchController = searchCoordinator.navigationController!
        searchController.tabBarItem = UITabBarItem(title: Tabs.search.rawValue, image: UIImage.init(systemName: "magnifyingglass.circle"), selectedImage: UIImage.init(systemName: "magnifyingglass.circle.fill"))
        
        
        Add(coordinator: trendingCoordinator)
        Add(coordinator: searchCoordinator)
        
        controllers.append(trendingController)
        controllers.append(searchController)

        tabBarController.setViewControllers(controllers, animated: true)
        tabBarController.tabBar.isTranslucent = true
        
    }
}
