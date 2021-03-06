//
//  BoardDetailCoordinator.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/26.
//

import UIKit
import NetworkFramework

final class BoardDetailCoordinator: NavigationCoordinator {
  
  // MARK: - Property
  
  private let boardId: Int
  private let router: Routable
  
  private var storyboard: UIStoryboard {
    UIStoryboard.load(storyboard: .boardDetail)
  }
  
  var navigationController: UINavigationController?
  private var invitationCoordinator: NavigationCoordinator!
  private var cardDetailCoordinator: NavigationCoordinator!
  private var cardAddCoordinator: NavigationCoordinator!
  
  
  // MARK: - Initializer
  
  init(router: Routable, boardId: Int) {
    self.router = router
    self.boardId = boardId
  }
  
  
  // MARK: - Method
  
  func start() -> UIViewController {
    guard let boardDetailViewController = storyboard.instantiateViewController(
            identifier: BoardDetailViewController.identifier, creator: { [weak self] coder in
              guard let self = self else { return UIViewController()}
              
              let boardService = BoardService(router: self.router, localDataSource: BoardLocalDataSource())
              let listService = ListService(router: self.router, localDataSource: ListLocalDataSource())
              let cardService = CardService(router: self.router)
              let activityService = ActivityService(router: self.router)
              let imageService = ImageService(router: self.router, cacheManager: CacheManager())
              
              let boardDetailViewModel = BoardDetailViewModel(
                boardService: boardService,
                listService: listService,
                cardService: cardService,
                boardId: self.boardId
              )
              
              let sideBarViewModel = SideBarViewModel(
                boardService: boardService,
                activityService: activityService,
                imageService: imageService,
                boardId: self.boardId,
                sideBarHeaderContentsFactory: SideBarHeaderContentsFactory()
              )
              let sideBarViewController = SideBarViewController(
                nibName: SideBarViewController.identifier,
                bundle: nil,
                viewModel: sideBarViewModel,
                coordinator: self
              )
              
              return BoardDetailViewController(
                coder: coder,
                viewModel: boardDetailViewModel,
                sideBarViewController: sideBarViewController
              )
            }) as? BoardDetailViewController else { return UIViewController() }
    
    boardDetailViewController.coordinator = self
    
    return boardDetailViewController
  }
}


// MARK: - Extension

extension BoardDetailCoordinator {
  
  func pop() {
    navigationController?.popViewController(animated: true)
  }
  
  func pushInvitation(delegate: InvitationViewControllerDelegate, members: [User]) {
    invitationCoordinator = InvitationCoordinator(router: router, boardId: boardId, members: members, delegate: delegate)
    invitationCoordinator.navigationController = navigationController
    
    let viewController = invitationCoordinator.start()
    let subNavigationController = UINavigationController()
    subNavigationController.pushViewController(viewController, animated: true)
    
    navigationController?.present(subNavigationController, animated: true)
  }
  
  func pushCardDetail(of cardId: Int) {
    cardDetailCoordinator = CardDetailCoordinator(id: cardId, router: self.router)
    cardDetailCoordinator.navigationController = navigationController
    
    let cardDetailViewController = cardDetailCoordinator.start()
    cardDetailViewController.hidesBottomBarWhenPushed = true
    
    navigationController?.pushViewController(cardDetailViewController, animated: true)
  }
  
  func presentCardAdd(to viewModel: ListViewModelProtocol) {
    cardAddCoordinator = CardAddCoordinator(router: router, viewModel: viewModel)
    
    let viewController = cardAddCoordinator.start()
    let subNavigationController = UINavigationController()
    subNavigationController.pushViewController(viewController, animated: true)
    
    cardAddCoordinator.navigationController = subNavigationController
    
    subNavigationController.modalPresentationStyle = .fullScreen
    navigationController?.present(subNavigationController, animated: true)
  }
}


