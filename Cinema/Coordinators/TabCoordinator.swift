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
    var loginCoordinator: LoginCoordinator
    var profileCoordinator: ProfileCoordinator
    var controllers: [UIViewController] = []
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        
        trendingCoordinator = TrendingCoordinator(navigationController: UINavigationController())
        searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
        loginCoordinator = LoginCoordinator(navigationController: UINavigationController())
        profileCoordinator = ProfileCoordinator(navigationController: UINavigationController())
        
    }
    
    override func start() {
        
        
        trendingCoordinator.start()
        let trendingController = trendingCoordinator.navigationController!
        trendingController.tabBarItem = UITabBarItem(title: Tabs.trending.rawValue, image: UIImage.init(systemName: "film"), selectedImage: UIImage.init(systemName: "film.fill"))
        Add(coordinator: trendingCoordinator)
        controllers.append(trendingController)
        
        searchCoordinator.start()
        let searchController = searchCoordinator.navigationController!
        searchController.tabBarItem = UITabBarItem(title: Tabs.search.rawValue, image: UIImage.init(systemName: "magnifyingglass.circle"), selectedImage: UIImage.init(systemName: "magnifyingglass.circle.fill"))
        Add(coordinator: searchCoordinator)
        controllers.append(searchController)
        
        if (Session.isUserConnected()) {
            if let user = Session.getUser() {
                profileCoordinator.user = user
                profileCoordinator.start()
                let profileController = profileCoordinator.navigationController!
                profileController.tabBarItem = UITabBarItem(title: Tabs.profile.rawValue, image: UIImage.init(systemName: "person"), selectedImage: UIImage.init(systemName: "person.fill"))
                Add(coordinator: profileCoordinator)
                controllers.append(profileController)
                profileCoordinator.profileViewController.profileViewModel.tabCoordinatorDelegate = self
            }
        } else {
            loginCoordinator.start()
            let loginController = loginCoordinator.navigationController!
            loginController.tabBarItem = UITabBarItem(title: Tabs.login.rawValue, image: UIImage.init(systemName: "person"), selectedImage: UIImage.init(systemName: "person.fill"))
            Add(coordinator: loginCoordinator)
            controllers.append(loginController)
            loginCoordinator.loginViewController.coordinatorDelegate = self
        }
        
        tabBarController.setViewControllers(controllers, animated: true)
        tabBarController.tabBar.isTranslucent = true
        
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
}

extension TabCoordinator: LoginViewModelCoordinatorDelegate {
    func userDidLogin(user: User) {
        
        Session.setUser(user)
        
        profileCoordinator.navigationController = UINavigationController()
        controllers = controllers.filter({ $0 !== loginCoordinator.navigationController })
        Remove(coordinator: loginCoordinator)
        loginCoordinator.dismiss()
        profileCoordinator.user = user
        profileCoordinator.start()
        let profileController = profileCoordinator.navigationController!
        profileController.tabBarItem = UITabBarItem(title: Tabs.profile.rawValue, image: UIImage.init(systemName: "person"), selectedImage: UIImage.init(systemName: "person.fill"))
        Add(coordinator: profileCoordinator)
        controllers.append(profileController)
        profileCoordinator.profileViewController.profileViewModel.tabCoordinatorDelegate = self
        tabBarController.setViewControllers(controllers, animated: false)
    }
}


extension TabCoordinator: ProfileViewModelTabCoordinatorDelegate {
    func userDidLogout() {
        
        Session.userDeconnected()
        
        loginCoordinator.navigationController = UINavigationController()
        controllers = controllers.filter({ $0 !== profileCoordinator.navigationController })
        Remove(coordinator: profileCoordinator)
        profileCoordinator.dismiss()
        loginCoordinator.start()
        let loginController = loginCoordinator.navigationController!
        loginController.tabBarItem = UITabBarItem(title: Tabs.login.rawValue, image: UIImage.init(systemName: "person"), selectedImage: UIImage.init(systemName: "person.fill"))
        Add(coordinator: loginCoordinator)
        controllers.append(loginController)
        loginCoordinator.loginViewController.coordinatorDelegate = self
        tabBarController.setViewControllers(controllers, animated: false)
    }
}
