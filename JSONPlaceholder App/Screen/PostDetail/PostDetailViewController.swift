//
//  PostDetailViewController.swift
//  JSONPlaceholder App
//
//  Created by Indra Permana on 10/07/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PostDetailViewController: UIViewController {
  
  private lazy var commentTableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.tableFooterView = UIView()
    tableView.allowsSelection = false
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 150
    tableView.register(UINib(nibName: "PostCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCommentCell")
    tableView.register(PostDetailTableViewCell.self, forCellReuseIdentifier: "PostDetailCell")
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
    let view = UIActivityIndicatorView(style: .medium)
    view.hidesWhenStopped = true
    return view
  }()
  
  public var postDetailViewModel: PostDetailViewModel
  
  private let disposeBag = DisposeBag()
  
  init(postDetailViewModel: PostDetailViewModel) {
    self.postDetailViewModel = postDetailViewModel
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    setupInfoLabel()
    setupIndicatorView()
    fetchPostDetail()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.systemBackground
    
    setupCommentTableView()
  }
  
}

extension PostDetailViewController {
  
  func fetchPostDetail() {
    
    commentTableView.delegate = self
    commentTableView.dataSource = self
    
    postDetailViewModel
      .postComments
      .drive(
        onNext: {[unowned self] _ in
          self.commentTableView.reloadData()
        }
      ).disposed(by: disposeBag)
    
    postDetailViewModel
      .isFetching
      .drive(indicatorView.rx.isAnimating)
      .disposed(by: disposeBag)
  }
  
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
  }
  
  
  func setupCommentTableView() {
    
    self.view.addSubview(commentTableView)
    
    commentTableView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 1 {
      return postDetailViewModel.postCommentsCount
    } else {
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return tableView.rowHeight
    } else {
      return 150
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 1 {
      return "Comments"
    } else {
      return nil
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.section == 0 {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailCell", for: indexPath) as? PostDetailTableViewCell else {
        return UITableViewCell()
      }
      
      cell.setupPost(title: postDetailViewModel.postTitle, username: postDetailViewModel.postUsername, body: postDetailViewModel.postBody)
      
      return cell
      
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCommentCell", for: indexPath) as? PostCommentTableViewCell else {
        return UITableViewCell()
      }
      
      if let viewModel = postDetailViewModel.viewModelForComment(at: indexPath.row) {
        
        // Email at Comments is Dummy :(
        // Not connected to Users at all
        
        let randomEmail = ["Chaim_McDermott@dana.io", "Karley_Dach@jasper.info", "Lucio_Hettinger@annie.ca"].randomElement() ?? "Lucio_Hettinger@annie.ca"
        
        cell.setComment(with: viewModel)
        cell.authorButtonCallback = {
          let userDetailViewModel = UserDetailViewModel(
            postService: PostService.shared,
            email: Driver<String>.of(randomEmail))
          
          self.goToUserDetail(with: userDetailViewModel)
        }
      }
      
      return cell
    }
  }
}

extension PostDetailViewController {
  
  func goToUserDetail(with userDetailViewModel: UserDetailViewModel) {
    
    let userDetailViewController = UserDetailViewController(userDetailViewModel: userDetailViewModel)
    
    self.navigationController?.pushViewController(userDetailViewController, animated: true)
  }
  
}
