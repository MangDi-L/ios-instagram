//
//  Comment.swift
//  Instagram
//
//  Created by mangdi on 6/19/24.
//

import Firebase

struct Comment: Equatable {
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.comment == rhs.comment && lhs.timestamp == rhs.timestamp && lhs.uid == rhs.uid
    }
    
    let comment: String
    let timestamp: Timestamp
    let uid: String
    var user: User?
    
    init(dictionary: [String: Any]) {
        self.comment = dictionary["comment"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
