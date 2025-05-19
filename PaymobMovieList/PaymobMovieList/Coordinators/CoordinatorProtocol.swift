//
//  CoordinatorProtocol.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
    func finish()
}

extension Coordinator {
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        guard let parent = self as? BaseCoordinator else { return }
        parent.childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        guard let parent = self as? BaseCoordinator else { return }
        guard let index = parent.childCoordinators.firstIndex(where: { $0 === coordinator }) else { return }
        parent.childCoordinators.remove(at: index)
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}
