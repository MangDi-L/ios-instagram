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
    
    var posts: [Post] = []
    var isShowProfilePosts: Bool = false
    var moveToCellIndex: IndexPath = IndexPath()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        if isShowProfilePosts { fetchProfilePostsUser() } else { fetchPosts() }
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
            
            if !posts.isEmpty {
                for number in 0...posts.count - 1 {
                    self.fetchPostsUser(post: posts[number], num: number)
                }
            }
            
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    private func fetchPostsUser(post: Post, num: Int) {
        UserService.fetchUser(uid: post.ownerUid) { user in
            self.posts[num].postUser = user
            self.collectionView.reloadData()
        }
    }
    
    private func fetchProfilePostsUser() {
        for number in 0...posts.count - 1 {
            fetchPostsUser(post: posts[number], num: number)
        }
        
        collectionView.scrollToItem(at: moveToCellIndex, at: .top, animated: false)
        return
    }
    
    private func fetchProfilePosts() {
        guard let uid = posts.first?.ownerUid else { return }
        
        PostService.fetchPosts(forUser: uid) { posts in
            self.posts = posts
            
            if !posts.isEmpty {
                for number in 0...posts.count - 1 {
                    self.fetchPostsUser(post: posts[number], num: number)
                }
            }
            
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
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
}
