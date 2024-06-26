//
//  NotificationViewModel.swift
//  Instagram
//
//  Created by mangdi on 6/24/24.
//

import UIKit

struct NotificationViewModel {
    var notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    var postImageUrl: URL? {
        return URL(string: notification.post?.imageUrl ?? "")
    }
    
    var profileImageUrl: URL? {
        return URL(string: notification.user?.profileImageUrl ?? "")
    }
    
    var notificationMessage: NSAttributedString {
        guard let username = notification.user?.username else { return NSAttributedString(string: "") }
        let message = notification.type.notificationMessage
        
        let attributedText = NSMutableAttributedString(string: username,
                                                       attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: message,
                                                 attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "  2m",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                              .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    
    var shouldHidePostImage: Bool {
        return self.notification.type == .follow
    }
    
    var shouldHideFollowButton: Bool {
        return notification.type != .follow
    }
    
    var followButtonText: String {
        switch notification.isUserFollowed {
        case .loading:
            return "Loading"
        case .follow:
            return "Following"
        case .unfollow:
            return "Follow"
        }
    }
    
    var followButtonBackgroundColor: UIColor {
        switch notification.isUserFollowed {
        case .loading:
            return .systemGray6
        case .follow:
            return .white
        case .unfollow:
            return .systemBlue
        }
    }
    
    var followButtonTextColor: UIColor {
        switch notification.isUserFollowed {
        case .loading:
            return .systemOrange
        case .follow:
            return .black
        case .unfollow:
            return .white
        }
    }
}
