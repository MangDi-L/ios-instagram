//
//  Notification.swift
//  Instagram
//
//  Created by mangdi on 6/24/24.
//

import Firebase

enum NotificationType: Int {
    case like
    case follow
    case comment
    
    var notificationMessage: String {
        switch self {
        case .like:
            return " liked your post."
        case .follow:
            return " started following you."
        case .comment:
            return " commented on your post."
        }
    }
}

struct Notification {
    let uid: String
    var postId: String?
    let timestamp: Timestamp
    let type: NotificationType
    let id: String
    var user: User?
    var post: Post?
    var isUserFollowed = false
    
    init(dictionary: [String: Any]) {
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.id = dictionary["id"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.postId = dictionary["postId"] as? String ?? ""
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
    }
}
