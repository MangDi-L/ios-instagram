//
//  NotificationViewModel.swift
//  Instagram
//
//  Created by mangdi on 6/24/24.
//

import UIKit

struct NotificationViewModel {
    let notification: Notification
    
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
        return notification.isUserFollowed ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        return notification.isUserFollowed ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return notification.isUserFollowed ? .black : .white
    }
}
