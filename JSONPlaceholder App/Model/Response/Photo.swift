//
//  Photo.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 10/07/21.
//

import Foundation

struct Photo: Codable {
  
  let albumId: Int
  let id: Int
  let title: String
  let url: String
  let thumbnailUrl: String
  
}
