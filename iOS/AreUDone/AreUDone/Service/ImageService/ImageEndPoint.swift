//
//  ImageEndPoint.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/03.
//

import Foundation
import NetworkFramework

enum ImageEndPoint {
  case fetchImage(url: String)
}

extension ImageEndPoint: EndPointable {
  var environmentBaseURL: String {
    switch self {
    case .fetchImage(let url):
      return "\(url)"
    }
  }
  
  var baseURL: URLComponents {
    guard let url = URLComponents(string: environmentBaseURL) else { fatalError() }
    return url
  }
  
  var query: HTTPQuery? {
    return nil
  }
  
  var httpMethod: HTTPMethod? {
    return .GET
  }
  
  var headers: HTTPHeader? {
   return nil
  }
  
  var bodies: HTTPBody? {
    return nil
  }
}
