//
//  PostTableViewCell.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 11/07/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var bodyLabel: UILabel!
  @IBOutlet weak var userInfoLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func set(viewModel: PostCellViewModel) {
    titleLabel.text = viewModel.title
    bodyLabel.text = viewModel.body
    userInfoLabel.text = viewModel.userInfo
    
  }
  
}
