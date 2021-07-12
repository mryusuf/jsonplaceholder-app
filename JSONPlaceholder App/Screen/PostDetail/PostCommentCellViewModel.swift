//
//  PostCommentCellViewModel.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 12/07/21.
//

import Foundation

struct PostCommentCellViewModel {
  
  private var comment: Comment
  private let emoji = ["👷🏾‍♂️", "👨‍🚀", "👩‍💻"].randomElement() ?? "👩‍💻"
  
  init(comment: Comment) {
    self.comment = comment
  }
  
  var author: String {
    return "\(emoji) \(comment.name)"
  }
  
  var body: String {
    return comment.body
  }
  
  var email: String {
    return comment.email
  }
  
}
