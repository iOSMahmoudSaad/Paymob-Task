//
//  AppCoordinator.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//


import UIKit

final class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init(navigationController: UINavigationController())
    }
    
    override func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        startMainScreen()
    }
    
    func startMainScreen() {
       
    }
}

