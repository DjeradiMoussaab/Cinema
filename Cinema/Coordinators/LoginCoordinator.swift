//
//  LoginCoordinator.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 24/1/2023.
//

import Foundation
import UIKit

// MARK: The Login Page Coordinator

class LoginCoordinator: BaseCoordinator {
    
    var navigationController: UINavigationController!
    
    var profileCoordinator: ProfileCoordinator?
    
    var loginViewController: LoginViewController!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

    }
    
    override func start() {
        self.loginViewController = LoginViewController()
        self.loginViewController.loginViewModelBuilder = {
            LoginViewModel(input: $0)
        }
        navigationController.pushViewController(loginViewController, animated: false)
    }
    
    func dismiss() {
        navigationController.popViewController(animated: false)
    }
    
}
