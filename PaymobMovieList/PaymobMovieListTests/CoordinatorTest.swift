//
//  CoordinatorTest.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

import XCTest
@testable import PaymobMovieList

class CoordinatorTests: XCTestCase {
    
    // MARK: - Test Properties
    var navigationController: UINavigationController!
    var mockCoordinator: MockCoordinator!
    var appCoordinator: AppCoordinator!
    var  window = UIWindow()
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
        mockCoordinator = MockCoordinator(navigationController: navigationController)
    }
    
    override func tearDown() {
        navigationController = nil
        mockCoordinator = nil
        appCoordinator = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testInitialization() {
        let baseCoordinator = BaseCoordinator(navigationController: navigationController)
        
        XCTAssertEqual(baseCoordinator.childCoordinators.count, 0, "Child coordinators should be empty on initialization")
        XCTAssertNil(baseCoordinator.parentCoordinator, "Parent coordinator should be nil on initialization")
        XCTAssertTrue(baseCoordinator.navigationController === navigationController, "Navigation controller should be set correctly")
    }
    
    func testAddChildCoordinator() {
        let parentCoordinator = MockCoordinator(navigationController: navigationController)
        let childCoordinator = MockCoordinator(navigationController: navigationController)
        
        parentCoordinator.addChildCoordinator(childCoordinator)
        
        XCTAssertEqual(parentCoordinator.childCoordinators.count, 1, "Child coordinator should be added")
        XCTAssertTrue(parentCoordinator.childCoordinators.first === childCoordinator, "Child coordinator reference should match")
        XCTAssertTrue(childCoordinator.parentCoordinator === parentCoordinator, "Parent coordinator should be set on child")
    }
    
    func testRemoveChildCoordinator() {
        let parentCoordinator = MockCoordinator(navigationController: navigationController)
        let childCoordinator = MockCoordinator(navigationController: navigationController)
        parentCoordinator.addChildCoordinator(childCoordinator)
        parentCoordinator.removeChildCoordinator(childCoordinator)
        
        XCTAssertEqual(parentCoordinator.childCoordinators.count, 0, "Child coordinator should be removed")
    }
    
    func testFinish() {
        let parentCoordinator = MockCoordinator(navigationController: navigationController)
        let childCoordinator = MockCoordinator(navigationController: navigationController)
        parentCoordinator.addChildCoordinator(childCoordinator)
        
        childCoordinator.finish()
        
        XCTAssertEqual(parentCoordinator.childCoordinators.count, 0, "Child coordinator should be removed when finished")
    }
    
    func testAppCoordinatorInitialization() {
        
        appCoordinator = AppCoordinator(window: window)
        
        XCTAssertEqual(appCoordinator.childCoordinators.count, 0, "App coordinator should have no children on initialization")
        XCTAssertNotNil(appCoordinator.navigationController, "Navigation controller should be initialized")
    }
    
    func testAppCoordinatorStart() {
        
        appCoordinator = AppCoordinator(window: window)
        
        appCoordinator.start()
        
        XCTAssertEqual(appCoordinator.childCoordinators.count, 1, "App coordinator should have one child after start")
        XCTAssertTrue(appCoordinator.childCoordinators.first is MoviesListCoordinator, "Child should be MoviesListCoordinator")
        XCTAssertTrue(window.rootViewController === appCoordinator.navigationController, "Window root view controller should be set")
    }
}

// MARK: - Mock Implementation

class MockCoordinator: BaseCoordinator {
    var startCalled = false
    
    override func start() {
        startCalled = true
    }
}

extension CoordinatorTests {
    class MockMoviesListCoordinator: BaseCoordinator {
        override func start() {
           
            print(">>> MockMoviesListCoordinator started <<<")
        }
    }
}

extension AppCoordinator {
    func startWithMockCoordinator(mockCoordinator: BaseCoordinator) {
        childCoordinators.append(mockCoordinator)
        mockCoordinator.start()
    }
}
