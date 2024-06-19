//
//  Comment.swift
//  Instagram
//
//  Created by mangdi on 6/19/24.
//

import Firebase

struct Comment {
    let comment: String
    let timestamp: Timestamp
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.comment = dictionary["comment"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
