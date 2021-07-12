//
//  UserDetailViewModel.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 12/07/21.
//

import Foundation
import RxSwift
import RxCocoa

class UserDetailViewModel {
  
  private let postService: PostService
  
  private let disposeBag = DisposeBag()
  private let _user = BehaviorRelay<UserAlbum?>(value: nil)
  private let _isFetching = BehaviorRelay<Bool>(value: false)
  private let _error = BehaviorRelay<String?>(value: nil)
  
  var isFetching: Driver<Bool> {
    return _isFetching.asDriver()
  }
  
  var user: Driver<UserAlbum?> {
    return _user.asDriver()
  }
  
  var hasError: Bool {
    return _error.value != nil
  }
  
  var error: Driver<String?> {
    return _error.asDriver()
  }
  
  var albumsCount: Int? {
    return _user.value?.albums.count
  }
  
  init(postService: PostService, email: Driver<String>) {
    self.postService = postService
    
    email
      .drive(
        onNext: { [weak self] (email) in
          self?.fetchUser(email: email)
        }
      ).disposed(by: disposeBag)
  }
  
  public func fetchUser(email: String) {
    _isFetching.accept(true)
    _user.accept(nil)
    _error.accept(nil)
    
    postService.fetchUser(email: email, successHandler: { [weak self] (user) in
      self?._isFetching.accept(false)
      self?._user.accept(user)
    }, errorHandler: {[weak self] (error) in
      self?._isFetching.accept(false)
      print(error.localizedDescription)
      self?._error.accept(error.localizedDescription)
    })
  }
  
  public func getThumbnailStringUrl(at index: Int, albumIndex: Int) -> String? {
    
    let album = _user.value?.albums[albumIndex]
    return album?.photos[index].thumbnailUrl
    
  }
  
  public func getPhotoStringUrl(at index: Int, albumIndex: Int) -> String? {
    
    let album = _user.value?.albums[albumIndex]
    return album?.photos[index].url
    
  }
  
  public func getPhotoTitle(at index: Int, albumIndex: Int) -> String? {
    
    let album = _user.value?.albums[albumIndex]
    return album?.photos[index].title
    
  }
  
  public func getAlbumName(at index: Int) -> String? {
    return _user.value?.albums[index].title
  }
  
}
