//
//  MemberUpdateCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/12/07.
//

import UIKit
import NetworkFramework

final class MemberUpdateCoordinator: NavigationCoordinator {
  
  // MARK:- Property
  
  private let router: Routable
  
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .memberUpdate)
  }
  
  var navigationController: UINavigationController?
  private let cardId: Int
  private let boardId: Int
  private let cardMember: [User]?
  
  
  // MARK:- Initializer
  
  init(router: Routable, cardId: Int, boardId: Int, cardMember: [User]?) {
    self.router = router
    self.cardId = cardId
    self.boardId = boardId
    self.cardMember = cardMember
  }
  
  
  // MARK:- Method
  
  func start() -> UIViewController {
    guard let memberUpdateViewController = storyboard.instantiateViewController(
            identifier: MemberUpdateViewController.identifier,
            creator: { [weak self] coder in
              guard let self = self else { return UIViewController() }
              let cardService = CardService(router: self.router)
              let boardService = BoardService(router: self.router)
              let imageService = ImageService(router: self.router, cacheManager: CacheManager())
              let viewModel = MemberUpdateViewModel(
                cardId: self.cardId,
                boardId: self.boardId,
                cardMember: self.cardMember,
                boardService: boardService,
                imageService: imageService,
                cardService: cardService
              )
              
              return MemberUpdateViewController(
                coder: coder,
                viewModel: viewModel
              )
            }) as? MemberUpdateViewController
    else { return UIViewController() }
    
    memberUpdateViewController.coordinator = self
    
    return memberUpdateViewController
  }
}


// MARK:- Extension

extension MemberUpdateCoordinator {
  
  func dismiss() {
    navigationController?.dismiss(animated: true)
  }
}
