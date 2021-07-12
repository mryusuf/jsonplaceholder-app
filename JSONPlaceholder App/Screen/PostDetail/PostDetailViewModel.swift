//
//  PostDetailViewModel.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 12/07/21.
//

import Foundation
import RxSwift
import RxCocoa

class PostDetailViewModel {
  
  private let postService: PostService
  
  private let disposeBag = DisposeBag()
  private let _postComments = BehaviorRelay<[Comment]>(value: [])
  private let _isFetching = BehaviorRelay<Bool>(value: false)
  private let _error = BehaviorRelay<String?>(value: nil)
  
  var postTitle: String?
  var postBody: String?
  var postUsername: String?
  
  var isFetching: Driver<Bool> {
    return _isFetching.asDriver()
  }
  
  var postComments: Driver<[Comment]> {
    return _postComments.asDriver()
  }
  
  var hasError: Bool {
    return _error.value != nil
  }
  
  var error: Driver<String?> {
    return _error.asDriver()
  }
  
  var postCommentsCount: Int {
    return _postComments.value.count
  }
  
  
  init(postService: PostService, postHome: Driver<PostHome>) {
    self.postService = postService
    
    postHome
      .drive(
        onNext: { [weak self] (postHome) in
          
          self?.postTitle = postHome.title.capitalized
          self?.postBody = postHome.body
          self?.postUsername = postHome.username
          self?.fetchPostComment(postHome: postHome)
        }
      ).disposed(by: disposeBag)
  }
  
  public func fetchPostComment(postHome: PostHome) {
    _isFetching.accept(true)
    _postComments.accept([])
    _error.accept(nil)
    
    postService.fetchPostComments(for: postHome, successHandler: { [weak self] (comments) in
      
      self?._isFetching.accept(false)
      self?._postComments.accept(comments)
    }, errorHandler: {[weak self] (error) in
      self?._isFetching.accept(false)
      self?._error.accept(error.localizedDescription)
    })
  }
  
  public func viewModelForComment(at index: Int) -> PostCommentCellViewModel? {
    guard index < _postComments.value.count else {
      return nil
    }
    
    return PostCommentCellViewModel(comment: _postComments.value[index])
  }
  
  
}
