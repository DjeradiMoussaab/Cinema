//
//  TrendingCoordinator.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 28/12/2022.
//

import Foundation
import UIKit

// MARK: The Trending Page Coordinator

class TrendingCoordinator: BaseCoordinator {
    
    var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        
        let viewController = TrendingViewController()
        navigationController.pushViewController(viewController, animated: true)
        
    }
    
    
}
