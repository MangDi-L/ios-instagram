//
//  NotificationController.swift
//  Instagram
//
//  Created by mangdi on 5/25/24.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

final class NotificationController: UITableViewController {
    
    // MARK: - Properties
    
    private var notifications: [Notification] = [] {
        didSet { tableView.reloadData() }
    }
    
    private let refresher = UIRefreshControl()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchNotifications()
    }
    
    // MARK: - API
    
    private func fetchNotifications() {
        NotificationService.fetchNotifications { notifications in
            self.notifications = notifications
            self.checkIfUserIsFollowed()
        }
    }
    
    private func checkIfUserIsFollowed() {
        notifications.forEach { notification in
            guard notification.type == .follow else { return }
            
            UserService.checkIfUserIsFollowed(uid: notification.uid) { isFollowed in
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                    self.notifications[index].isUserFollowed = isFollowed ? .follow : .unfollow
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func handleRefresh() {
        fetchNotifications()
        refresher.endRefreshing()
    }
    
    // MARK: - Helpers
    
    private func configureTableView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Notification"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
}

// MARK: - UITableViewDataSource

extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? NotificationCell ?? NotificationCell()
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - NotificationCellDelegate

extension NotificationController: NotificationCellDelegate {
    func cell(_ cell: NotificationCell, wansToFollow uid: String) {
        guard let tab = tabBarController as? MainTabController else { return }
        guard let currentUser = tab.user else { return }
        
        showLoader(true)
        
        UserService.follow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.isUserFollowed = .follow
            
            NotificationService.uploadNotification(toUid: uid,
                                                   fromUid: currentUser.uid,
                                                   type: .follow)
            
            UserService.updateUserFeedAfterFollowing(opponentUid: uid, didFollow: true)
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String) {
        showLoader(true)
        
        UserService.unfollow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.isUserFollowed = .unfollow
            
            UserService.updateUserFeedAfterFollowing(opponentUid: uid, didFollow: false)
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToViewPost post: Post) {
        guard let tab = tabBarController as? MainTabController else { return }
        guard let currentUser = tab.user else { return }
        let profileController = ProfileController(user: currentUser)
        navigationController?.pushViewController(profileController, animated: true)
        profileController.moveToFeedControllerFromNotificationPost(postId: post.postId)
    }
    
    func cell(_ cell: NotificationCell, wantsToProfile user: User) {
        let profileController = ProfileController(user: user)
        navigationController?.pushViewController(profileController, animated: true)
    }
}
