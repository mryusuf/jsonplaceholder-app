//
//  PostCellViewModel.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 11/07/21.
//

import Foundation

struct PostCellViewModel {
  
  private var post: PostHome
  
  init(post: PostHome) {
    self.post = post
  }
  
  var title: String {
    return post.title.capitalized
  }
  
  var body: String {
    return post.body
  }
  
  var userInfo: String {
    return "🤠 " + post.username + "  🏢 " + post.company
  }
}
