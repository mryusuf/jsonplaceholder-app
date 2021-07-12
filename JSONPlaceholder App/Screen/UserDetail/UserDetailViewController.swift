//
//  UserDetailViewController.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 12/07/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import SDWebImage
import Lightbox

class UserDetailViewController: UIViewController {
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 30)
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var emailLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body)
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var addressLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body)
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var companyLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .justified
    label.font = .preferredFont(forTextStyle: .body)
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var infoLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.secondaryLabel
    label.textAlignment = .center
    label.isHidden = true
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var userDataStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .fill
    return stackView
  }()
  
  private lazy var userIndicatorView: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(style: .medium)
    view.hidesWhenStopped = true
    return view
  }()
  
  private lazy var userAlbumsIndicatorView: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(style: .medium)
    view.hidesWhenStopped = true
    return view
  }()
  
  private lazy var albumsCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.register(UserPhotoHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCell")
    collectionView.register(UserPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "UserPhotoCell")
    return collectionView
  }()
  
  public var userDetailViewModel: UserDetailViewModel
  var userAlbumsViewModel: UserAlbumsViewModel?
  
  private let disposeBag = DisposeBag()
  
  init(userDetailViewModel: UserDetailViewModel) {
    self.userDetailViewModel = userDetailViewModel
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    self.title = "User Detail"
    setupInfoLabel()
    setupIndicatorView()
    fetchUserDetail()
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.systemBackground
  }
  
}

extension UserDetailViewController {
  
  func fetchUserDetail() {
    userDetailViewModel
      .user
      .drive(
        onNext: { [unowned self] (user) in
          if let user = user {
            
            self.setupUserData(user: user)
            self.setupAlbumsCollectionView()
            self.albumsCollectionView.reloadData()
          }
        }
      ).disposed(by: disposeBag)
    
    userDetailViewModel
      .isFetching
      .drive(userIndicatorView.rx.isAnimating)
      .disposed(by: disposeBag)
    
    userDetailViewModel
      .error
      .drive(onNext: {[unowned self] (error) in
        self.infoLabel.isHidden = !self.userDetailViewModel.hasError
        self.infoLabel.text = error
      })
      .disposed(by: disposeBag)
    
  }
  
  func setupInfoLabel() {
    view.addSubview(infoLabel)
    
    infoLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(-125)
    }
  }
  
  func setupIndicatorView() {
    view.addSubview(userIndicatorView)
    view.addSubview(userAlbumsIndicatorView)
    
    userIndicatorView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(-125)
    }
    
    userAlbumsIndicatorView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(125)
    }
  }
  
  func setupAlbumsCollectionView() {
    albumsCollectionView.delegate = self
    albumsCollectionView.dataSource = self
    
    view.addSubview(albumsCollectionView)
    
    let zero = CGFloat(0)
    albumsCollectionView.contentInset = UIEdgeInsets(top: zero, left: zero, bottom: zero, right: zero)
    albumsCollectionView.snp.makeConstraints { make in
      make.top.equalTo(userDataStackView.snp.bottom).offset(10)
      make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
      make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
      make.bottom.equalToSuperview()
      make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
    }
    
  }
  
  func setupUserData(user: UserAlbum) {
    
    nameLabel.text = user.name
    emailLabel.text = user.email
    addressLabel.text = "\(user.address.street), \(user.address.suite)"
    companyLabel.text = user.company.name
    
    userDataStackView.addArrangedSubview(nameLabel)
    userDataStackView.addArrangedSubview(emailLabel)
    userDataStackView.addArrangedSubview(addressLabel)
    userDataStackView.addArrangedSubview(companyLabel)
    
    view.addSubview(userDataStackView)
    
    userDataStackView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
      make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
    }
    
  }
}

extension UserDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    if let albumsCount = userDetailViewModel.albumsCount {
      return albumsCount
    } else {
      return 0
    }
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPhotoCell", for: indexPath) as? UserPhotoCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    if let photoStringUrl = userDetailViewModel.getThumbnailStringUrl(at: indexPath.row, albumIndex: indexPath.section) {
    
      cell.setupUserPhoto(url: photoStringUrl)
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.frame.size.width, height: 50)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let title = userDetailViewModel.getPhotoTitle(at: indexPath.row, albumIndex: indexPath.section) ?? ""
    view.backgroundColor = UIColor.systemGray
    collectionView.isHidden = true
    view.isUserInteractionEnabled = false
    UIApplication.shared.beginIgnoringInteractionEvents()
    userAlbumsIndicatorView.startAnimating()
    
    if let photoStringUrl = userDetailViewModel.getPhotoStringUrl(at: indexPath.row, albumIndex: indexPath.section) {
      let imgDownloader = SDWebImageDownloader()
      imgDownloader.downloadImage(with: URL(string: photoStringUrl)) { image, data, error, bool in
        self.view.backgroundColor = UIColor.systemBackground
        self.userAlbumsIndicatorView.stopAnimating()
        self.view.isUserInteractionEnabled = true
        UIApplication.shared.endIgnoringInteractionEvents()
        collectionView.isHidden = false
        if error != nil {
          return
        }
        
        if let image = image {
          self.showPhoto(for: image, title: title)
        }
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    if kind == UICollectionView.elementKindSectionHeader {
      if let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCell", for: indexPath) as? UserPhotoHeaderView {
      
        if let title = userDetailViewModel.getAlbumName(at: indexPath.section) {
        
          reusableview.setupTitle(title: title)
        }
        
        return reusableview
      }
      
    }
      
    return UICollectionReusableView()
    
  }
}

extension UserDetailViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
      
    let width = collectionView.bounds.size.width / 5 - 4
    let height = collectionView.bounds.size.height / 5 - 4
    return CGSize( width: width, height: height )
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return CGFloat(2)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets.init(top: 8, left: 2, bottom: 8, right: 2)
  }
}

extension UserDetailViewController: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate {
  func showPhoto(for image: UIImage, title: String) {
    let image = [LightboxImage(image: image, text: title)]
    
    let lightBoxController = LightboxController(images: image, startIndex: 0)
    lightBoxController.pageDelegate = self as LightboxControllerPageDelegate
    lightBoxController.dismissalDelegate = self as LightboxControllerDismissalDelegate
    lightBoxController.dynamicBackground = true
    lightBoxController.title = title
    
    self.present(lightBoxController, animated: true, completion: nil)
  }
  
  
  func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
    
  }
  
  func lightboxControllerWillDismiss(_ controller: LightboxController) {
    
  }
}
