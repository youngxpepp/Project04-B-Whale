//
//  CardContentView.swift
//  AreUDone
//
//  Created by 서명렬 on 2020/11/24.
//

import UIKit

final class CardContentView: UIView {

  // MARK:- Property

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.nanumB(size: 18)
    
    return label
  }()
  private lazy var commentImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(systemName: "text.bubble")
    imageView.image = image
    imageView.tintColor = .black
    
    return imageView
  }()
  private lazy var commentCountLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.nanumB(size: 14)
    
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
  
  func updateContentView(with card: Card) {
    titleLabel.text = card.title
    commentCountLabel.text = String(card.commentCount)
  }
}


// MARK:- Extension Configure Method

private extension CardContentView {
  
  func configure() {
    addSubview(titleLabel)
    addSubview(commentImageView)
    addSubview(commentCountLabel)
    
    configureView()
    configureTitleLabel()
    configureCommentImageView()
    configureCommentCountLabel()
  }
  
  func configureView() {
    backgroundColor = .systemGray6
    layer.maskedCorners = [
      .layerMinXMinYCorner,
      .layerMinXMaxYCorner
    ]
    layer.cornerCurve = .continuous
    layer.cornerRadius = 5
  }
  
  func configureTitleLabel() {
    NSLayoutConstraint.activate([
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
      titleLabel.trailingAnchor.constraint(equalTo: commentImageView.leadingAnchor, constant: -10)
    ])
  }
  
  func configureCommentImageView() {
    NSLayoutConstraint.activate([
      commentImageView.widthAnchor.constraint(equalToConstant: 20),
      commentImageView.heightAnchor.constraint(equalTo: commentImageView.widthAnchor),
      commentImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
      commentImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  func configureCommentCountLabel() {
    NSLayoutConstraint.activate([
      commentCountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
      commentCountLabel.leadingAnchor.constraint(equalTo: commentImageView.trailingAnchor, constant: 5),
      commentCountLabel.centerYAnchor.constraint(equalTo: commentImageView.centerYAnchor)
    ])
  }
}
