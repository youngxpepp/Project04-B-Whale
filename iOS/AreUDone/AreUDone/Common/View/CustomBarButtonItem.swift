//
//  BackButton.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/29.
//

import UIKit

final class CustomBarButtonItem: UIBarButtonItem {
  
  // MARK: - Property

  var handler: () -> Void
  private let button = UIButton()
  private let imageName: String
  
  // MARK: - Initializer
  
  init(imageName: String, handler: @escaping () -> Void) {
    self.handler = handler
    self.imageName = imageName
    
    super.init()
    
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Method
  
  private func configure() {
    
    button.setImage(UIImage(systemName: imageName), for: .normal)
    button.tintColor = .white
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button.widthAnchor.constraint(equalToConstant: 30),
      button.heightAnchor.constraint(equalTo: button.widthAnchor)
    ])
    
    customView = button
  }
  
  @objc private func buttonTapped() {
    handler()
  }
}
