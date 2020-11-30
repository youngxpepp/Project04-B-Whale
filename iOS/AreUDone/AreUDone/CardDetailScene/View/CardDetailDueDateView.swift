//
//  CardDetailDueDateView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/26.
//

import UIKit

final class CardDetailDueDateView: UIView {
  
  // MARK:- Property
  
  private lazy var titleLable: UILabel = {
    let label = UILabel()
    label.text = "마감 날짜"
    label.font = UIFont(name: "AmericanTypewriter-Bold", size: 20)
    
    return label
  }()
  
  private lazy var dueDateLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont(name: "AmericanTypewriter", size: 15)
    
    return label
  }()
  
  // MARK:- Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }

  
  // MARK:- Method
  
  func update(dueDate: String) {
    dueDateLabel.text = dueDate
  }
}


private extension CardDetailDueDateView {
  
  func configure() {
    addSubview(titleLable)
    addSubview(dueDateLabel)
    
    configureTitleLabel()
    configureDueDateLabel()
  }
  
  func configureTitleLabel() {
    titleLable.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      titleLable.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      titleLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      titleLable.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
    ])
  }
  
  func configureDueDateLabel() {
    dueDateLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      dueDateLabel.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 4),
      dueDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
      dueDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
      dueDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
    ])
  }
}
