//
//  TabbarCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/21.
//

import UIKit
import NetworkFramework


final class TabbarCoordinator: Coordinator {
  
  // MARK: - Property
  
  weak var parentCoordinator: Coordinator?
  private var controllers: [UINavigationController] = []
  
  private let router: Routable
  private let signInCoordinator: SigninCoordinator
  private let tabbarController: UITabBarController
  private let coordinators: [NavigationCoordinator]
  
  
  // MARK: - Initializer
  
  init(
    router: Routable,
    signInCoordinator: SigninCoordinator,
    tabbarController: UITabBarController,
    coordinators: [NavigationCoordinator]
  ) {
    self.router = router
    self.signInCoordinator = signInCoordinator
    self.tabbarController = tabbarController
    self.coordinators = coordinators
  }
  
  
  // MARK: - Method
  
  func start() -> UIViewController {
    coordinators.enumerated().forEach { (index, coordinator) in
      let itemContents = TabbarItemContentsFactory().load(order: index)
      configureController(with: coordinator, itemContents)
    }
    
    tabbarController.viewControllers = controllers
    
    return tabbarController
  }
  
  private func configureController(
    with coordinator: NavigationCoordinator,
    _ itemContents: (name: String, image: String)
  ) {
    var coordinator = coordinator
    
    if let settingCoordinator = coordinator as? SettingCoordinator {
      settingCoordinator.sceneCoordinator = parentCoordinator
    }
    
    let navigationController = UINavigationController()
    
    let viewController = coordinator.start()
    coordinator.navigationController = navigationController
    
    navigationController.pushViewController(viewController, animated: false)
    navigationController.tabBarItem = UITabBarItem(
      title: itemContents.name,
      image: UIImage(systemName: itemContents.image),
      tag: 0
    )
    
    let font = UIFont.nanumB(size: 16)
    navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
    
    controllers.append(navigationController)
  }
}
