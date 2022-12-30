//
//  Coordinator.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 28/12/2022.
//

import Foundation

// MARK: The Coordinator Protocol

protocol Coordinator: AnyObject {
    
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    
    func Add(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func Remove(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0 !== coordinator })
    }
    
}

// MARK: The Base Implementation of Coordinator Protocol

class BaseCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    func start() {
        fatalError("children should implement 'start'.")
    }
    
}
