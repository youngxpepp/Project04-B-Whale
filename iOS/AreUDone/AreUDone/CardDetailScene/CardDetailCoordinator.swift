//
//  CardDetailCoordinator.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/25.
//

import UIKit
import NetworkFramework

final class CardDetailCoordinator: NavigationCoordinator {
  
  // MARK:- Property
  
  private let router: Routable
  
  private var storyboard: UIStoryboard {
    return UIStoryboard.load(storyboard: .cardDetail)
  }
  
  private let id: Int
  
  var navigationController: UINavigationController?
  private var contentInputCoordinator: NavigationCoordinator!
  private var calendarPickerCoordinator: CalendarPickerCoordinator!
  private var memberUpdateCoordinator: MemberUpdateCoordinator!
  
  
  // MARK:- Initializer
  
  init(id: Int, router: Routable) {
    self.id = id
    self.router = router
  }
  
  
  // MARK:- Method
  
  func start() -> UIViewController {
    guard let cardDetailViewController = storyboard.instantiateViewController(
            identifier: CardDetailViewController.identifier,
            creator: { [weak self] coder in
              guard let self = self else { return UIViewController() }
                      
              let imageService = ImageService(
                router: self.router,
                cacheManager: CacheManager()
              )
              let cardService = CardService(
                router: self.router,
                localDataSource: CardLocalDataSource()
              )
              let userService = UserService(router: self.router)
              let commentService = CommentService(
                router: self.router,
                commentLocalDataSource: CommentLocalDataSource()
              )
              let viewModel = CardDetailViewModel(
                id: self.id,
                cardService: cardService,
                imageService: imageService,
                userService: userService,
                commentService: commentService
              )
              
              return CardDetailViewController(
                coder: coder,
                viewModel: viewModel
              )}) as? CardDetailViewController
    else { return UIViewController() }
    
    cardDetailViewController.cardDetailCoordinator = self
    
    return cardDetailViewController
  }
}


// MARK:- Extension

extension CardDetailCoordinator {
  
  func pushToContentInput(
    with content: String,
    delegate: ContentInputViewControllerDelegate
  ) {
    contentInputCoordinator = ContentInputCoordinator(content: content, router: router)
    contentInputCoordinator.navigationController = navigationController
    guard let contentInputViewController = contentInputCoordinator.start()
            as? ContentInputViewController
    else { return }
    contentInputViewController.delegate = delegate
    
    navigationController?.pushViewController(
      contentInputViewController,
      animated: true
    )
  }
  
  func presentCalendar(
    with stringToDate: String,
    delegate: CalendarPickerViewControllerDelegate
  ) {
    let date = stringToDate.toDateAndTimeFormat()
    calendarPickerCoordinator = CalendarPickerCoordinator(router: router, selectedDate: date)
    calendarPickerCoordinator.navigationController = navigationController
    
    guard let calendarPickerViewController = calendarPickerCoordinator.start()
            as? CalendarPickerViewController
    else { return }
    
    calendarPickerViewController.delegate = delegate
    navigationController?.present(calendarPickerViewController, animated: true)
  }
  
  func presentMemberUpdate(
    with cardId: Int,
    boardId: Int,
    cardMember: [User]?,
    delegate: MemberUpdateViewControllerDelegate
  ) {
    memberUpdateCoordinator = MemberUpdateCoordinator(
      router: router,
      cardId: cardId,
      boardId: boardId,
      cardMember: cardMember
    )
    memberUpdateCoordinator.navigationController = navigationController
    
    guard let memberUpdateViewController = memberUpdateCoordinator.start()
            as? MemberUpdateViewController
    else { return }
    memberUpdateViewController.delegate = delegate
    
    let subNavigationViewController = UINavigationController()
    
    subNavigationViewController.pushViewController(memberUpdateViewController, animated: true)
    navigationController?.present(subNavigationViewController, animated: true)
  }
}
