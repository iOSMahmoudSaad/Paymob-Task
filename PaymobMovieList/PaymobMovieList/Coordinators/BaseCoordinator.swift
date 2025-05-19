//
//  BaseCoordinator.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

import UIKit

class BaseCoordinator: Coordinator {
    
   var childCoordinators: [Coordinator] = []
   let navigationController: UINavigationController
   weak var parentCoordinator: Coordinator?
   
   init(navigationController: UINavigationController) {
       self.navigationController = navigationController
   }
   
   func start() {
       fatalError("Start method must be implemented by subclass")
   }
   
   deinit {
       #if DEBUG
       print("🗑️ \(type(of: self)) deallocated")
       #endif
   }
}
