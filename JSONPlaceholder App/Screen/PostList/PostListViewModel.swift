//
//  PostListViewModel.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 11/07/21.
//

import Foundation
import RxSwift
import RxCocoa

class PostListViewModel {
  
  private let postService: PostService
  
  private let disposeBag = DisposeBag()
  private let _posts = BehaviorRelay<[PostHome]>(value: [])
  private let _isFetching = BehaviorRelay<Bool>(value: false)
  private let _error = BehaviorRelay<String?>(value: nil)
  
  var isFetching: Driver<Bool> {
    return _isFetching.asDriver()
  }
  
  var posts: Driver<[PostHome]> {
    return _posts.asDriver()
  }
  
  var hasError: Bool {
    return _error.value != nil
  }
  
  var error: Driver<String?> {
    return _error.asDriver()
  }
  
  var postsCount: Int {
    return _posts.value.count
  }
  
  init(postService: PostService) {
    self.postService = postService
  }
  
  public func fetchPosts() {
    _posts.accept([])
    _isFetching.accept(true)
    _error.accept(nil)
    
    postService.fetchPosts(successHandler: { [weak self] (posts) in
      self?._isFetching.accept(false)
      self?._posts.accept(posts)
    }, errorHandler: {[weak self] (error) in
      self?._isFetching.accept(false)
      self?._error.accept(error.localizedDescription)
    })
  }
  
  public func viewModelForPost(at index: Int) -> PostCellViewModel? {
    guard index < _posts.value.count else {
      return nil
    }
    
    return PostCellViewModel(post: _posts.value[index])
  }
  
  public func postHomeForPost(at index: Int) -> PostHome? {
    
    guard index < _posts.value.count else {
      return nil
    }
    
    return _posts.value[index]
  }
  
}
