//
//  UserAlbumsViewModel.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 12/07/21.
//

import Foundation
import RxSwift
import RxCocoa

/*
 Not Used for now...
 But ideally we can separate the View Model for a page to minimize loading time,
 because each data can be fetched individually
 */
class UserAlbumsViewModel {
  
  private let postService: PostService
  
  private let disposeBag = DisposeBag()
  private let _albums = BehaviorRelay<[Album]>(value: [])
  private let _isFetching = BehaviorRelay<Bool>(value: false)
  private let _error = BehaviorRelay<String?>(value: nil)
  
  var isFetching: Driver<Bool> {
    return _isFetching.asDriver()
  }
  
  var albums: Driver<[Album]> {
    return _albums.asDriver()
  }
  
  var hasError: Bool {
    return _error.value != nil
  }
  
  var error: Driver<String?> {
    return _error.asDriver()
  }
  
  init(postService: PostService, userId: Driver<Int>) {
    self.postService = postService
    
    userId
      .drive(
        onNext: { [weak self] (userId) in
          self?.fetchUserAlbums(userId: userId.description)
        }
      ).disposed(by: disposeBag)
  }
  
  public func fetchUserAlbums(userId: String) {
    _isFetching.accept(true)
    _albums.accept([])
    _error.accept(nil)
    
    postService.fetchUserAlbums(userId: userId, successHandler: { [weak self] (albums) in
      self?._isFetching.accept(false)
      print(albums)
      self?._albums.accept(albums)
    }, errorHandler: {[weak self] (error) in
      self?._isFetching.accept(false)
      self?._error.accept(error.localizedDescription)
    })
  }
  
}
