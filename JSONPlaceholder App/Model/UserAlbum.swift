//
//  UserAlbum.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 12/07/21.
//

import Foundation

struct UserAlbum {
  
  let name: String
  let email: String
  let address: Address
  let company: Company
  let albums: [AlbumPhotos]
}


struct AlbumPhotos: Codable {
  
  let userId: Int
  let id: Int
  let title: String
  let photos: [Photo]
}
