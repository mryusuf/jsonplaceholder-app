//
//  Post.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 10/07/21.
//

import Foundation

struct Post: Codable {
  
  let userId: Int
  let id: Int
  let title: String
  let body: String
  
}
