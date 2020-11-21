//
//  CommentService.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/19.
//

import Foundation
import NetworkFramework

protocol CommentServiceProtocol {
  
}

class CommentService: CommentServiceProtocol {
  
  // MARK: - Property
  
  private let router: Routable
  
  
  // MARK: - Initializer
  
  init(router: Routable) {
    self.router = router
  }
  
  
  // MARK: - Method
  
}