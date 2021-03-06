//
//  SideBarBottomView.swift
//  AreUDone
//
//  Created by a1111 on 2020/12/03.
//

import UIKit


final class MemberFooterView: UICollectionReusableView, Reusable {
  
  // MARK: - Property
  
  weak var delegate: SideBarViewControllerProtocol?
  
  private lazy var baseView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.backgroundColor = .white
    view.layer.cornerRadius = 5
    view.layer.borderColor = UIColor.black.cgColor
    view.layer.borderWidth = 1
    
    return view
  }()
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    titleLabel.text = "초대하기"
    titleLabel.font = UIFont.nanumB(size: 20)
    
    return titleLabel
  }()
  
  
  // MARK: - Initializer
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
}


// MARK: - Extension Configure Method

private extension MemberFooterView {
  
  func configure() {
    addSubview(baseView)
    baseView.addSubview(titleLabel)
    
    configureBaseView()
    configureTitleLabel()
  }
  
  func configureBaseView() {
    NSLayoutConstraint.activate([
      baseView.centerXAnchor.constraint(equalTo: centerXAnchor),
      baseView.topAnchor.constraint(equalTo: topAnchor),
      baseView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
      baseView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
    ])
    
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(baseViewDidTapped))
    baseView.addGestureRecognizer(gestureRecognizer)
  }
  
  func configureTitleLabel() {
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: baseView.centerYAnchor)
    ])
  }
}


// MARK: - Extension objc Method

private extension MemberFooterView {
  
  @objc func baseViewDidTapped() {
    delegate?.pushInvitation()
  }
}
