//
//  ProfileDetailsCoordinator.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 2/5/2023.
//

import Foundation
import UIKit

// MARK: The Profile Details Coordinator

class ProfileDetailsCoordinator: BaseCoordinator {
    
    var navigationController: UINavigationController!
    var profileDetailsViewController: ProfileDetailsViewController!

    var user: User!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        self.profileDetailsViewController = ProfileDetailsViewController()
        self.profileDetailsViewController.profileDetailsViewModelBuilder = {
            ProfileDetailsViewModel(input: $0)
        }
        profileDetailsViewController.profileDetailsViewModel = ProfileDetailsViewModel(input: user)
        navigationController.pushViewController(profileDetailsViewController, animated: false)
    }
    
    func dismiss() {
        navigationController.popViewController(animated: false)
    }
    
}
