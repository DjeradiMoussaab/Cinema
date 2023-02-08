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
        /*self.profileViewController.profileViewModelBuilder = {
            ProfileViewModel(input: $0)
        }*/
       // self.profileViewController.profileViewModel = self.profileViewController.profileViewModelBuilder((user))
    }
    
    override func start() {
        self.profileViewController = ProfileViewController()
        profileViewController.profileViewModel = ProfileViewModel(user: user)
        navigationController.pushViewController(profileViewController, animated: false)
    }
    
    func dismiss() {
        navigationController.popViewController(animated: false)
    }
    
}
