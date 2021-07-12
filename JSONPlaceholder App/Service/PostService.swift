//
//  PostService.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 10/07/21.
//

import Foundation

protocol PostServiceProtocol {
  
  func fetchPosts(successHandler: @escaping (_ response: [PostHome]) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
  func fetchPostComments(for post: PostHome, successHandler: @escaping (_ response: [Comment]) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
  func fetchUser(email: String, successHandler: @escaping (_ response: UserAlbum) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
  func fetchUserAlbums(userId: String, successHandler: @escaping (_ response: [Album]) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
  
}

class PostService: PostServiceProtocol {
  
  public static let shared = PostService()
  private let urlSession = URLSession.shared
  
  /*
   Get Posts and each of it's user info
   */
  func fetchPosts(successHandler: @escaping ([PostHome]) -> Void, errorHandler: @escaping (Error) -> Void) {
   
    guard let url = URL(string: Endpoint.posts.url) else {
      errorHandler(FetchError.invalidEndpoint)
      return
    }
    
    let dispatchGroup = DispatchGroup()
    var postHomeList: [PostHome] = []
    
    urlSession.dataTask(with: url) { (data, response, error) in
      if error != nil {
        errorHandler(FetchError.invalidResponse)
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
        errorHandler(FetchError.invalidResponse)
        return
      }
      
      guard let data = data else {
        errorHandler(FetchError.noData)
        return
      }
      
      do {
        let postsResponse = try JSONDecoder().decode([Post].self, from: data)
        
        // Get User Info per User
        let userTemps: [Int: User] = [:]
        for post in postsResponse {
          dispatchGroup.enter()
          let userId = post.userId
          if userTemps[userId] == nil {
            if let userUrl = URL(string: Endpoint.users.url + "/" + userId.description) {
              self.urlSession.dataTask(with: userUrl) { (data, response, error) in
                defer {dispatchGroup.leave()}
                if error != nil {
                  return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                  return
                }
                
                guard let data = data else {
                  return
                }
                
                do {
                  let userResponse = try JSONDecoder().decode(User.self, from: data)
                  let postHome = PostHome(
                    id: post.id,
                    title: post.title,
                    body: post.body,
                    username: userResponse.username,
                    company: userResponse.company.name
                  )
                  postHomeList.append(postHome)
                  
                } catch {
                  print("error fetch user info")
                  errorHandler(FetchError.serializationError)
                }
              }.resume()
            }
          }
        }
        
        dispatchGroup.notify(queue: .main) {
          successHandler(postHomeList)
        }
        
        
      } catch {
        // Handle error
        errorHandler(FetchError.serializationError)
      }
    }.resume()
    
  }
  
  /*
   Get Post Detail and it's comments
   */
  func fetchPostComments(for post: PostHome, successHandler: @escaping ([Comment]) -> Void, errorHandler: @escaping (Error) -> Void) {
    guard let url = URL(string: (Endpoint.posts.url + "/" + post.id.description + "/comments") ) else {
      errorHandler(FetchError.invalidEndpoint)
      return
    }
    
    urlSession.dataTask(with: url) { (data, response, error) in
      if error != nil {
        errorHandler(FetchError.invalidResponse)
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
        errorHandler(FetchError.invalidResponse)
        return
      }
      
      guard let data = data else {
        errorHandler(FetchError.noData)
        return
      }
      
      do {
        
        let commentsResponse = try JSONDecoder().decode([Comment].self, from: data)
        
        DispatchQueue.main.async {
          successHandler(commentsResponse)
        }
        
      } catch {
        // Handle Error
        errorHandler(FetchError.serializationError)
      }
    }.resume()
  }
  
  func fetchUser(email: String, successHandler: @escaping (UserAlbum) -> Void, errorHandler: @escaping (Error) -> Void) {
    guard var urlComponents = URLComponents(string: Endpoint.users.url) else {
      return
    }
    
    let queryItem = URLQueryItem(name: "email", value: email)
    urlComponents.queryItems = [queryItem]
    
    let dispatchGroup = DispatchGroup()
    
    var albumPhotos: [AlbumPhotos] = []
    
    if let url = urlComponents.url {
      urlSession.dataTask(with: url) { (data, response, error) in
        if error != nil {
          errorHandler(FetchError.invalidResponse)
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
          return
        }
        
        guard let data = data else {
          errorHandler(FetchError.noData)
          return
        }
        
        do {
          
          let userResponse = try JSONDecoder().decode([User].self, from: data)
          
          guard userResponse.count > 0 else {
            errorHandler(FetchError.noData)
            return
          }
          
          guard var urlComponents = URLComponents(string: Endpoint.albums.url) else {
            errorHandler(FetchError.invalidEndpoint)
            return
          }
          let user = userResponse[0]
          let queryItem = URLQueryItem(name: "userId", value: user.id.description)
          urlComponents.queryItems = [queryItem]
          
          if let url = urlComponents.url {
            self.urlSession.dataTask(with: url) { (data, response, error) in
              if error != nil {
                errorHandler(FetchError.invalidResponse)
                return
              }
              
              guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                errorHandler(FetchError.invalidResponse)
                return
              }
              
              guard let data = data else {
                errorHandler(FetchError.noData)
                return
              }
              
              do {
                
                let albumResponse = try JSONDecoder().decode([Album].self, from: data)
                
                guard albumResponse.count > 0 else {
                  errorHandler(FetchError.noData)
                  return
                }
                
                for album in albumResponse {
                  
                  dispatchGroup.enter()
                  
                  guard var urlComponents = URLComponents(string: Endpoint.photos.url) else {
                    errorHandler(FetchError.invalidEndpoint)
                    return
                  }
                  let queryItem = URLQueryItem(name: "albumId", value: album.id.description)
                  urlComponents.queryItems = [queryItem]
                  
                  if let url = urlComponents.url {
                    
                    self.urlSession.dataTask(with: url) { (data, response, error) in
                      defer {dispatchGroup.leave()}
                      if error != nil {
                        errorHandler(FetchError.invalidResponse)
                        return
                      }
                      
                      guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                        errorHandler(FetchError.invalidResponse)
                        return
                      }
                      
                      guard let data = data else {
                        errorHandler(FetchError.noData)
                        return
                      }
                      
                      do {
                        
                        let photoResponse = try JSONDecoder().decode([Photo].self, from: data)
                        
                        guard photoResponse.count > 0 else {
                          errorHandler(FetchError.noData)
                          return
                        }
                        
                        
                        let albumPhoto = AlbumPhotos(userId: user.id, id: album.id, title: album.title, photos: photoResponse)
                        albumPhotos.append(albumPhoto)
                      } catch {
                        // Handle Error
                        errorHandler(FetchError.serializationError)
                      }
                    }.resume()
                  }
                  
                }
                
                dispatchGroup.notify(queue: .main) {
                  
                  let userAlbum = UserAlbum(name: user.name, email: user.email, address: user.address, company: user.company, albums: albumPhotos)
                  successHandler(userAlbum)
                }
                
                
              } catch {
                // Handle Error
                errorHandler(FetchError.serializationError)
              }
            }.resume()
          }
          
        } catch {
          // Handle Error
          errorHandler(FetchError.serializationError)
        }
      }.resume()
    }
  }
  
  /*
   Get User and it's albums
   */
  func fetchUserAlbums(userId: String, successHandler: @escaping (_ response: [Album]) -> Void, errorHandler: @escaping(_ error: Error) -> Void) {
    guard var urlComponents = URLComponents(string: Endpoint.albums.url) else {
      errorHandler(FetchError.invalidEndpoint)
      return
    }
    
    let queryItem = URLQueryItem(name: "userId", value: userId)
    urlComponents.queryItems = [queryItem]
    
    if let url = urlComponents.url {
      urlSession.dataTask(with: url) { (data, response, error) in
        if error != nil {
          errorHandler(FetchError.invalidResponse)
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
          errorHandler(FetchError.invalidResponse)
          return
        }
        
        guard let data = data else {
          errorHandler(FetchError.noData)
          return
        }
        
        do {
          
          let albumResponse = try JSONDecoder().decode([Album].self, from: data)
          
          guard albumResponse.count > 0 else {
            errorHandler(FetchError.noData)
            return
          }
          
          DispatchQueue.main.async {
            successHandler(albumResponse)
          }
          
        } catch {
          // Handle Error
          errorHandler(FetchError.serializationError)
        }
      }.resume()
    }
  }
  
}
