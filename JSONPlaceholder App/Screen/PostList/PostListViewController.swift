//
//  PostListViewController.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 10/07/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PostListViewController: UIViewController {
  
  private lazy var postTableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.tableFooterView = UIView()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 100
    tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
    return tableView
  }()
  
  private lazy var infoLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.secondaryLabel
    label.textAlignment = .center
    label.isHidden = true
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var indicatorView: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(style: .large)
    view.color = .systemGray
    view.hidesWhenStopped = true
    return view
  }()
  
  var postListViewModel: PostListViewModel!
  private let disposeBag = DisposeBag()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    setupInfoLabel()
    setupIndicatorView()
    fetchPosts()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Posts"
    self.view.backgroundColor = UIColor.systemBackground
    
    postTableView.delegate = self
    postTableView.dataSource = self
    
    setupTableView()
  }
  
  func fetchPosts() {
    postListViewModel = PostListViewModel(
      postService: PostService.shared
    )
    
    postListViewModel.fetchPosts()
    
    postListViewModel
      .posts
      .drive(
        onNext: {[unowned self] (data) in
//          print(data)
          self.postTableView.reloadData()
        }
      ).disposed(by: disposeBag)
    
    postListViewModel
      .isFetching
      .drive(indicatorView.rx.isAnimating)
      .disposed(by: disposeBag)
  }
  
}

extension PostListViewController {
  
  func setupInfoLabel() {
    view.addSubview(infoLabel)
    
    infoLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }
  
  
  func setupIndicatorView() {
    view.addSubview(indicatorView)
    
    indicatorView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    
    indicatorView.startAnimating()
  }
  
  func setupTableView() {
    view.addSubview(postTableView)
    postTableView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
      make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
      make.bottom.equalToSuperview()
    }
  }
}

extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return postListViewModel.postsCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
    
    if let viewModel = postListViewModel.viewModelForPost(at: indexPath.row) {
      cell.set(viewModel: viewModel)
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let postHome = postListViewModel.postHomeForPost(at: indexPath.row) {
      let viewModel = PostDetailViewModel(
        postService: PostService.shared,
        postHome: Driver<PostHome>.of(postHome)
      )
      
      self.goToPostDetail(with: viewModel)
    }
  }
}

extension PostListViewController {
  
  func goToPostDetail(with postDetailViewModel: PostDetailViewModel) {
    
    let postDetailViewController = PostDetailViewController(postDetailViewModel: postDetailViewModel)
    
    self.navigationController?.pushViewController(postDetailViewController, animated: true)
  }
  
}
