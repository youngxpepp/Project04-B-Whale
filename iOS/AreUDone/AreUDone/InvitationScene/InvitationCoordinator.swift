//
//  InvitationCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/05.
//

import UIKit
import NetworkFramework

final class InvitationCoordinator: NavigationCoordinator {
  
  // MARK: - Property
  
  private let router: Routable
  private let boardId: Int
  private let members: [User]
  private weak var delegate: InvitationViewControllerDelegate?
  
  private var storyboard: UIStoryboard {
    UIStoryboard.load(storyboard: .invitation)
  }
  
  var navigationController: UINavigationController?
  
  
  // MARK: - Initializer
  
  init(
    router: Routable,
    boardId: Int,
    members: [User],
    delegate: InvitationViewControllerDelegate? = nil
  ) {
    self.router = router
    self.boardId = boardId
    self.members = members
    self.delegate = delegate
  }
  
  
  // MARK: - Method
  
  func start() -> UIViewController {
    
    guard let invitationViewController = storyboard.instantiateViewController(
            identifier: InvitationViewController.identifier,
            creator: { [weak self] coder in
              guard let self = self else { return UIViewController() }
              
              let userService = UserService(router: self.router)
              let boardService = BoardService(router: self.router)
              let imageSerivce = ImageService(router: self.router, cacheManager: CacheManager())
              
              let viewModel = InvitationViewModel(
                userService: userService,
                boardService: boardService,
                imageService: imageSerivce,
                boardId: self.boardId,
                members: self.members
              )
              
              let viewController = InvitationViewController(coder: coder, viewModel: viewModel)
              viewController?.delegate = self.delegate
              return viewController
            }) as? InvitationViewController else { return UIViewController() }
    
    invitationViewController.coordinator = self
    
    return invitationViewController
  }
}


// MARK: - Extension

extension InvitationCoordinator {
  
  func dismiss() {
    navigationController?.dismiss(animated: true)
  }
}
