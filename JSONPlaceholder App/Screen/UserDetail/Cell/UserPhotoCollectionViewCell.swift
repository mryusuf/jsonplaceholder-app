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
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func setupUserPhoto
  
}
