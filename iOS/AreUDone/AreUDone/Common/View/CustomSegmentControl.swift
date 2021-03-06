//
//  CustomSegmentControl.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/06.
//

import UIKit

protocol CustomSegmentedControlDelegate: AnyObject {
  
  func change(to segmented: TitleChangeable)
}

final class CustomSegmentedControl: UIView {
  
  // MARK: - Property
  
  weak var delegate: CustomSegmentedControlDelegate?
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: buttons)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    
    return stackView
  }()
  private var buttonTitles: [String]!
  private var buttons: [UIButton]!
  private var selectorView: UIView!
  
  private var unSelectedtextColor: UIColor = .gray
  
  private var selectorViewColor: UIColor = .black
  private var selectorTextColor: UIColor = .black
  private var selectedIndex : Int = 0
  
  private let widthRate: CGFloat = 0.5
  private let heightRate: CGFloat = 0.8
  
  
  // MARK: - Initializer
  
  convenience init(frame: CGRect, buttonTitle: [String]) {
    self.init(frame: frame)
    self.buttonTitles = buttonTitle
    
    configure()
  }
  
  
  // MARK: - Method
  
  func setButtonTitles(buttonTitles:[String]) {
    self.buttonTitles = buttonTitles
    self.configure()
  }
}


// MARK: - Extension configure method

private extension CustomSegmentedControl {
  
  func configure() {
    configureView()
    configureButton()
    
    configureStackView()
    configureSelectorView()
  }
  
  func configureView() {
    layer.cornerRadius = 10
    layer.maskedCorners = [
      .layerMinXMaxYCorner,
      .layerMaxXMaxYCorner
    ]
    addShadow(
      offset: CGSize(width: 0, height: -1),
      radius: 2,
      opacity: 0.5
    )
    
    backgroundColor = UIColor.white
  }
  
  private func configureButton() {
    buttons = [UIButton]()
    
    buttonTitles.forEach { buttonTitle in
      let button = UIButton(type: .system)
      
      button.titleLabel?.font = UIFont.nanumR(size: 18)
      button.setTitle(buttonTitle, for: .normal)
      button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
      button.setTitleColor(unSelectedtextColor, for: .normal)
      buttons.append(button)
    }
    
    buttons[0].setTitleColor(selectorTextColor, for: .normal)
  }
  
  private func configureSelectorView() {
    layoutIfNeeded()
    let padding: CGFloat = 10
    let selectorWidth = (UIScreen.main.bounds.width - padding * 2) / CGFloat(buttonTitles.count)
    
    selectorView = UIView(
      frame: CGRect(
        x: selectorWidth * widthRate - (selectorWidth * widthRate / 2),
        y: frame.height * heightRate,
        width: selectorWidth * widthRate,
        height: 2
      )
    )
    selectorView.backgroundColor = selectorViewColor
    addSubview(selectorView)
  }
  
  private func configureStackView() {
    addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.leftAnchor.constraint(equalTo: leftAnchor),
      stackView.rightAnchor.constraint(equalTo: rightAnchor)
    ])
  }
}


// MARK: - Extension objc

private extension CustomSegmentedControl {
  
  @objc func buttonAction(sender: UIButton) {
    buttons.enumerated().forEach { (index, button) in
      button.setTitleColor(unSelectedtextColor, for: .normal)
      
      guard button == sender else { return }
      
      let selectorWidth = frame.width / CGFloat(buttonTitles.count)
      let selectorPosition = selectorWidth * CGFloat(index)
      selectedIndex = index
      
      switch delegate {
      case is CalendarViewController:
        delegate?.change(to: CardSegment.allCases[selectedIndex])
        
      case is BoardListViewController:
        delegate?.change(to: BoardSegment.allCases[selectedIndex])
        
      default:
        return
      }
      
      UIViewPropertyAnimator(duration: 0.15, curve: .easeInOut) {
        self.selectorView.frame.origin.x =
          selectorPosition + selectorWidth * (self.widthRate) - (selectorWidth * self.widthRate / 2)
      }.startAnimation()
      
      button.setTitleColor(selectorTextColor, for: .normal)
    }
  }
}
