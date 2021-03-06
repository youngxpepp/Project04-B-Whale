//
//  CalendarViewModel.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/21.
//

import Foundation

protocol CalendarViewModelProtocol {
  
  func bindingUpdateCardCollectionView(handler: @escaping (Cards) -> Void)
  func bindingUpdateDate(handler: @escaping (String) -> Void)
  func bindingEmptyIndicatorView(handler: @escaping (Bool) -> Void)
  
  func fetchUpdateDailyCards(withOption option: FetchDailyCardsOption)
  func fetchDailyCards()
  func changeDate(to date: String, direction: Direction?)
  func deleteCard(for cardId: Int, completionHandler: @escaping () -> Void)
  func checkCardCollectionView(isEmpty: Bool)
}

extension CalendarViewModelProtocol {
  
  func fetchUpdateDailyCards(withOption option: FetchDailyCardsOption = .allCard) {
    fetchUpdateDailyCards(withOption: option)
  }
}

final class CalendarViewModel: CalendarViewModelProtocol {
  
  // MARK: - Property
  
  private var updateCardCollectionViewHandler: ((Cards) -> Void)?
  private var updateDateHandler: ((String) -> Void)?
  private var emptyIndicatorViewHandler: ((Bool) -> Void)?
  
  private let cardService: CardServiceProtocol
  private var fetchDailyCardOption: FetchDailyCardsOption = .allCard {
    didSet {
      if oldValue != fetchDailyCardOption {
        fetchDailyCards()
      }
    }
  }
  private var selectedDate: Date = Date() {
    didSet {
      fetchDailyCards()
    }
  }
  
  
  // MARK:- Initializer
  
  init(cardService: CardServiceProtocol) {
    self.cardService = cardService
  }
  
  
  // MARK:- Method
  
  func changeDate(to dateAsString: String, direction: Direction?) {
    guard
      let direction = direction
    else {
      selectedDate = dateAsString.toDateAndTimeFormat()
      return
    }
    
    let date = dateAsString.toDateFormat()
    let value = direction.value
    let calendar = Calendar(identifier: .gregorian)
    
    if let updatedDate = calendar.date(byAdding: .day, value: value, to: date) {
      selectedDate = updatedDate
    }
  }
  
  func deleteCard(for cardId: Int, completionHandler: @escaping () -> Void) {
    cardService.deleteCard(for: cardId) { result in
      switch result {
      case .success(()):
        completionHandler()
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func fetchUpdateDailyCards(withOption option: FetchDailyCardsOption = .allCard) {
    fetchDailyCardOption = option
  }
  
  func fetchDailyCards() {
    cardService.fetchDailyCards(
      dateString: selectedDate.toString(),
      option: fetchDailyCardOption
    ) { result in
      switch result {
      case .success(let cards):
        self.updateDateHandler?(self.selectedDate.toString())
        self.updateCardCollectionViewHandler?(cards)
        self.emptyIndicatorViewHandler?(cards.cards.isEmpty)
        
      case .failure(let error):
        self.updateDateHandler?(self.selectedDate.toString())
        self.updateCardCollectionViewHandler?(Cards())
        print(error)
      }
    }
  }
  
  func checkCardCollectionView(isEmpty: Bool) {
    emptyIndicatorViewHandler?(isEmpty)
  }
}


// MARK:- Extension BindUI

extension CalendarViewModel {
  
  func bindingUpdateCardCollectionView(handler: @escaping (Cards) -> Void) {
    updateCardCollectionViewHandler = handler
  }
  
  func bindingUpdateDate(handler: @escaping (String) -> Void) {
    updateDateHandler = handler
  }
  
  func bindingEmptyIndicatorView(handler: @escaping (Bool) -> Void) {
    emptyIndicatorViewHandler = handler
  }
}
