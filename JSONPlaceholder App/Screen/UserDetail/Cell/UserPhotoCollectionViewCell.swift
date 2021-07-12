//
//  UserPhotoCollectionViewCell.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 12/07/21.
//

import UIKit
import SnapKit
import SDWebImage

class UserPhotoCollectionViewCell: UICollectionViewCell {
  
  private lazy var photoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 10
    return imageView
  }()
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func setupUserPhoto(url: String) {
    
    photoImageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
    photoImageView.sd_setImage(with: URL(string: url)!, completed: nil)
    
    contentView.addSubview(photoImageView)
    
    photoImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
}

class UserPhotoHeaderView: UICollectionReusableView {
  
  private lazy var headerTitleLabel: UILabel = {
    let view = UILabel()
    view.font = .preferredFont(forTextStyle: .title3)
    view.textColor = .white
    view.textAlignment = .center
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.lightGray
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupTitle(title: String) {
    headerTitleLabel.text = title
    
    addSubview(headerTitleLabel)
    
    headerTitleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}
