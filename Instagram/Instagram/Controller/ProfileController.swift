//
//  ProfileController.swift
//  Instagram
//
//  Created by mangdi on 5/25/24.
//

import UIKit

enum ProfileCellType {
    case grid
    case bookmark
}

final class ProfileController: UICollectionViewController {
    
    private let cellIdentifier = "ProfileCell"
    private let headerIdentifier = "ProfileHeader"
    
    // MARK: - Properties
    
    private var user: User
    private var posts: [Post] = []
    private var likedPosts: [Post] = []
    var cellType: ProfileCellType = .grid
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkIfUserIsFollowed()
        fetchUserStats()
        fetchPosts { }
        fetchLikedPosts()
    }
    
    // MARK: - API
    
    private func checkIfUserIsFollowed() {
        UserService.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    private func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    private func fetchPosts(completion: @escaping() -> Void) {
        PostService.fetchPosts(forUser: user.uid) { posts in
            self.posts = posts
            self.collectionView.reloadData()
            completion()
        }
    }
    
    private func fetchLikedPosts() {
        PostService.fetchLikedPost(from: user) { posts in
            self.likedPosts = posts
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func configureCollectionView() {
        navigationItem.title = user.username
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ProfileCell.self,
                                forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
    }
    
    func moveToFeedControllerFromNotificationPost(postId: String) {
        fetchPosts {
            let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
            
            controller.feedType = .profile
            controller.posts = self.posts
            
            let index = self.posts.firstIndex { post in
                return post.postId == postId
            }
            
            guard let index = index else { return }
            
            controller.moveToCellIndex = IndexPath(row: index, section: 0)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch cellType {
        case .grid:
            return posts.count
        case .bookmark:
            return likedPosts.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ProfileCell ?? ProfileCell()
        
        switch cellType {
        case .grid:
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        case .bookmark:
            cell.viewModel = PostViewModel(post: likedPosts[indexPath.row])
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as? ProfileHeader ?? ProfileHeader()
        header.delegate = self
        
        header.viewModel = ProfileHeaderViewModel(user: user)
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.feedType = .profile
        controller.moveToCellIndex = indexPath
        
        switch cellType {
        case .grid:
            controller.posts = posts
        case .bookmark:
            controller.posts = likedPosts
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}

// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        guard let tab = tabBarController as? MainTabController else { return }
        guard let currentUser = tab.user else { return }
        
        if user.isCurrentUser {
            // 프로필 편집버튼 누를시
            let profileEditController = ProfileEditController()
            profileEditController.user = user
            profileEditController.delegate = self
            navigationController?.pushViewController(profileEditController, animated: true)
        } else if user.isFollowed {
            UserService.unfollow(uid: user.uid) { error in
                self.user.isFollowed = false
                self.fetchUserStats()
                
                UserService.updateUserFeedAfterFollowing(opponentUid: user.uid, didFollow: false)
            }
        } else {
            UserService.follow(uid: user.uid) { error in
                self.user.isFollowed = true
                self.fetchUserStats()
                
                NotificationService.uploadNotification(toUid: user.uid,
                                                       fromUid: currentUser.uid,
                                                       type: .follow)
                
                UserService.updateUserFeedAfterFollowing(opponentUid: user.uid, didFollow: true)
            }
        }
    }
    
    func header(_ profileHeader: ProfileHeader, changeCellType: ProfileCellType) {
        switch changeCellType {
        case .grid:
            cellType = .grid
        case .bookmark:
            cellType = .bookmark
        }
        
        collectionView.reloadData()
    }
}

extension ProfileController: ProfileEditControllerDelegate {
    func profileImageOrNameChanged(user: User) {
        self.user = user
        navigationItem.title = user.username
        self.collectionView.reloadData()
        
        guard let tab = tabBarController as? MainTabController else { return }
        guard let nav = tab.viewControllers?[.zero] as? UINavigationController else { return }
        let feed = nav.topViewController as? FeedController
        feed?.handleRefresh()
    }
}
