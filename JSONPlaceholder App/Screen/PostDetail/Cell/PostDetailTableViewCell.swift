//
//  PostDetailTableViewCell.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 12/07/21.
//

import UIKit
import SnapKit

class PostDetailTableViewCell: UITableViewCell {
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 30)
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var usernameLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .callout)
    label.textColor = UIColor.secondaryLabel
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var bodyLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .justified
    label.font = .preferredFont(forTextStyle: .body)
    label.numberOfLines = 0
    return label
  }()
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    contentView.backgroundColor = UIColor.systemBackground
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  
  func setupPost(title: String?, username: String?, body: String?) {
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(usernameLabel)
    contentView.addSubview(bodyLabel)
    
    titleLabel.text = title ?? ""
    usernameLabel.text = username ?? ""
    bodyLabel.attributedText = NSAttributedString(string: body ?? "")
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(20)
      make.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).offset(20)
      make.trailing.equalToSuperview()
    }
    
    usernameLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(30)
      make.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).offset(20)
      make.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing).offset(20)
    }
    
    bodyLabel.snp.makeConstraints { make in
      make.top.equalTo(usernameLabel.snp.bottom).offset(10)
      make.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).offset(20)
      make.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing).offset(20)
      make.bottom.equalToSuperview().offset(-50)
    }
  }
  
}
