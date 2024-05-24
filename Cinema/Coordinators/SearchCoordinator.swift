//
//  SearchCoordinator.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 17/1/2023.
//

import Foundation
import UIKit

// MARK: The Search Page Coordinator

class SearchCoordinator: BaseCoordinator {
    
    var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        
        let viewController = SearchViewController()
        navigationController.pushViewController(viewController, animated: true)
        
    }
    
}

