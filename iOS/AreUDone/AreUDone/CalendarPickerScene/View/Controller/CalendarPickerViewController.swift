//
//  CalendarPickerViewController.swift
//  AreUDone
//
//  Created by a1111 on 2020/11/24.
//

import UIKit


final class CalendarPickerViewController: UIViewController {
  
  enum Section {
    case main
  }
  
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Day>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Day>
  
  
  // MARK: - Property
  
  private lazy var dimmedBackgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    return view
  }()
  private lazy var headerView = CalendarPickerHeaderView()
  private lazy var collectionView: CalendarCollectionView = {
    
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    let collectionView = CalendarCollectionView(
      frame: .zero,
      collectionViewLayout: layout
    ) { direction in
      
      switch direction {
      case .right:
        self.viewModel.fetchUpdatedCalendar(to: -1)
        
      case .left:
        self.viewModel.fetchUpdatedCalendar(to: 1)
      }
    }
    collectionView.delegate = self
    
    return collectionView
  }()
    
  private let viewModel: CalendarPickerViewModelProtocol
  lazy var dataSource = configureDataSource()
  weak var delegate: CalendarViewControllerDelegate?
  weak var coordinator: CalendarPickerViewCoordinator?
  
  // MARK: - Initializer
  
  init(viewModel: CalendarPickerViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: nil)
    
    modalPresentationStyle = .overCurrentContext
    modalTransitionStyle = .crossDissolve
  }
  
  required init?(coder: NSCoder) {
    fatalError("This controller must be initialized with code")
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindUI()
    addGestureRecognizer()
    configureConstraints()
    
    viewModel.fetchInitialCalendar()
  }
}

private extension CalendarPickerViewController {
  
  func bindUI() {
    viewModel.bindingInitializeDate { [weak self] days, selectedDate in
      self?.updateSnapshot(with: days, animatingDifferences: false)
      self?.headerView.baseDate = selectedDate
    }
    
    viewModel.bindingUpdateCalendar { [weak self] days, selectedDate in
      self?.updateSnapshot(with: days)
      self?.headerView.baseDate = selectedDate
    }
    
    viewModel.bindingSendSelectedDate { [weak self] date in
      self?.delegate?.send(selectedDate: date)
    }
  }
  
  func addGestureRecognizer() {
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimmerViewDidTapped))
    dimmedBackgroundView.addGestureRecognizer(tapRecognizer)
  }
  
  @objc func dimmerViewDidTapped() {
    viewModel.sendSelectedDate()
    coordinator?.dismiss()
//    dismiss(animated: true) // 프레젠테이션 로직 옮겨주기
  }
}


// MARK: Constraints 설정

private extension CalendarPickerViewController {
  
  func configureConstraints() {
    dimmedBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    headerView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(dimmedBackgroundView)
    view.addSubview(collectionView)
    view.addSubview(headerView)
    
    configureDimmerViewConstraints()
    configureCollectionViewConstraints()
    configureHeaderViewConstraints()
  }
  
  func configureDimmerViewConstraints() {
    NSLayoutConstraint.activate([
      dimmedBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      dimmedBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      dimmedBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
      dimmedBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  func configureCollectionViewConstraints() {
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(
        equalTo: view.readableContentGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(
        equalTo: view.readableContentGuide.trailingAnchor),
      collectionView.centerYAnchor.constraint(
        equalTo: view.centerYAnchor,
        constant: 10),
      collectionView.heightAnchor.constraint(
        equalTo: view.heightAnchor,
        multiplier: 0.5)
    ])
  }
  
  func configureHeaderViewConstraints() {
    NSLayoutConstraint.activate([
      headerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
      headerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
      headerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 85)
    ])
  }
}


// MARK: Diffable DataSource

private extension CalendarPickerViewController {
  
  func configureDataSource() -> DataSource {
    let datasource = DataSource(collectionView: collectionView) { collectionView, indexPath, day -> UICollectionViewCell? in
      let cell: CalendarDateCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.day = day
      
      return cell
    }
    
    return datasource
  }
  
  func updateSnapshot(with item: [Day], animatingDifferences: Bool = true) {
    var snapshot = Snapshot()
    
    snapshot.appendSections([.main])
    snapshot.appendItems(item)
    
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
}


// MARK: UICollectionViewDelegateFlowLayout

extension CalendarPickerViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarDateCollectionViewCell,
          let day = cell.day else { return }
    
    viewModel.updateSelectedDate(to: day.date)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width = Int(collectionView.frame.width / 7)
    let height = Int(collectionView.frame.height) / 6
    return CGSize(width: width, height: height)
  }
}


