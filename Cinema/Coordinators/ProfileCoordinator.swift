//
//  ProfileCoordinator.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 31/1/2023.
//

import Foundation
import UIKit

// MARK: The Profile Page Coordinator

class ProfileCoordinator: BaseCoordinator {
    
    var navigationController: UINavigationController!
    var profileViewController: ProfileViewController!

    var user: User!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

       // self.profileViewController.profileViewModel = self.profileViewController.profileViewModelBuilder((user))
    }
    
    override func start() {
        self.profileViewController = ProfileViewController()
        self.profileViewController.profileViewModelBuilder = {
            ProfileViewModel(input: $0)
        }
        profileViewController.profileViewModel = ProfileViewModel(input: user)
        profileViewController.profileViewModel.profileCoordinatorDelegate = self
        navigationController.pushViewController(profileViewController, animated: false)
    }
    
    func dismiss() {
        navigationController.popViewController(animated: false)
    }
    
}


extension ProfileCoordinator: ProfileViewModelProfileCoordinatorDelegate {
    func accountDetailsSelected() {
    
    }
    
    func settingsSelected() {
        
    }
    
    func favoritesSelected() {
        let favoriteViewController = FavoriteViewController()
        navigationController.pushViewController(favoriteViewController, animated: true)
    }
}
