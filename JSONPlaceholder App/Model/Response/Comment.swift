//
//  Comment.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 10/07/21.
//

import Foundation

struct Comment: Codable {
  
  let postId: Int
  let id: Int
  let name: String
  let email: String
  let body: String
  
}
