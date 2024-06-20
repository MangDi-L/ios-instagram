//
//  FeedController.swift
//  Instagram
//
//  Created by mangdi on 5/25/24.
//

import UIKit
import Firebase

private let reuseIdentifier = "FeedCell"

final class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    
    // 이거에다가 옵저버 달아줄 생각을 아예 못함;;
    var posts: [Post] = [] {
        didSet { collectionView.reloadData() }
    }
    var isShowProfilePosts: Bool = false
    var moveToCellIndex: IndexPath = IndexPath()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        if isShowProfilePosts { moveToPostIndex() } else { fetchPosts() }
    }
    
    // MARK: - Actions
    
    @objc private func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        } catch {
            print("DEBUG: Failed to sign out!")
        }
    }
    
    @objc func handleRefresh() {
        if isShowProfilePosts { fetchProfilePosts() } else { fetchPosts() }
    }
    
    // MARK: - API
    
    private func fetchPosts() {
        PostService.fetchPosts { posts in
            self.posts = posts
            self.collectionView.refreshControl?.endRefreshing()
            self.checkIfUserLikedPosts()
        }
    }
    
    private func fetchProfilePosts() {
        guard let uid = posts.first?.ownerUid else { return }
        
        PostService.fetchPosts(forUser: uid) { posts in
            self.posts = posts
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    private func checkIfUserLikedPosts() {
        posts.forEach { post in
            PostService.checkIfUserLikedPost(post: post) { didLike in
                // 이 클로저로 넘어오는 포스트는 무조건 like한 포스트만 넘어온다
                if let index = self.posts.firstIndex(where: { $0.postId == post.postId }) {
                    self.posts[index].didLike = didLike
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        if !isShowProfilePosts {
            // 로그아웃 버튼
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(handleLogout))
        }
        
        navigationItem.title = "Feed"
        
        // 새로고침
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
    private func moveToPostIndex() {
        collectionView.scrollToItem(at: moveToCellIndex, at: .top, animated: false)
    }
}

// MARK: - UICollectionViewDataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FeedCell ?? FeedCell()
        cell.delegate = self
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 8 + 40 + 8 // 이미지크기 + 프로필 및 패딩값
        height += 50 // 이미지 바로 밑
        height += 60 // 부수적인것들
        return CGSize(width: width, height: height)
    }
}

// MARK: - FeedCellDelegate

extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeedCell, didLike post: Post) {
        cell.viewModel?.post.didLike.toggle()
        
        if post.didLike {
            PostService.unlikePost(post: post) { error in
                cell.likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
        } else {
            PostService.likePost(post: post) { error in
                cell.likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
            }
        }
    }
}
