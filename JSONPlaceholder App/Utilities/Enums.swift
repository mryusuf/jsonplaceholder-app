//
//  Enums.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 10/07/21.
//

import Foundation

class API {
  static let baseUrl = "https://jsonplaceholder.typicode.com/"
}

public enum Endpoint {
  
  case posts
  case users
  case comments
  case albums
  case photos
  
  public var url: String {
    switch self {
    case .posts:
      return API.baseUrl + "posts"
    case .users:
      return API.baseUrl + "users"
    case .comments:
      return API.baseUrl + "comments"
    case .albums:
      return API.baseUrl + "albums"
    case .photos:
      return API.baseUrl + "photos"
    }
  }
  
}

public enum FetchError: Error {
  
  case apiError
  case invalidEndpoint
  case invalidResponse
  case noData
  case serializationError
}
