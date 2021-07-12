//
//  PostCommentTableViewCell.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 12/07/21.
//

import UIKit

class PostCommentTableViewCell: UITableViewCell {
  
  @IBOutlet weak var authorButton: UIButton!
  @IBOutlet weak var bodyLabel: UILabel!
  
  var authorButtonCallback: () -> () = {}
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    authorButton.addTarget(self, action: #selector(didTapAuthorButton), for: .touchUpInside)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @objc func didTapAuthorButton() {
    authorButtonCallback()
  }
  
  func setComment(with viewModel: PostCommentCellViewModel) {
    authorButton.setTitle(viewModel.author, for: .normal)
    bodyLabel.text = viewModel.body
  }
  
}
