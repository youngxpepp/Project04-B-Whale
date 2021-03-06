//
//  String+.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/25.
//

import UIKit

enum DateDividerFormat: String {
  case dot = "."
  case dash = "-"
}

extension String {
  
  var trimmed: String {
    self.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  func toDateFormat(withDividerFormat dividerFormat: DateDividerFormat = .dash) -> Date {
    let dateFormatter = DateFormatter()
    let divider = dividerFormat.rawValue
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "yyyy\(divider)MM\(divider)dd"
    
    return dateFormatter.date(from: self) ?? Date()
  }
  
  func toDateAndTimeFormat(withDividerFormat dividerFormat: DateDividerFormat = .dash) -> Date {
    let dateFormatter = DateFormatter()
    let divider = dividerFormat.rawValue
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "yyyy\(divider)MM\(divider)dd HH:mm:ss"
    
    return dateFormatter.date(from: self) ?? Date()
  }
  
  func toUIColor() -> UIColor {
      var rgbValue: UInt64 = 0
      let droppedString = self.dropFirst()

      Scanner(string: String(droppedString)).scanHexInt64(&rgbValue)
      
      return UIColor(
          red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
          green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
          blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
          alpha: CGFloat(1.0)
      )
  }
}
