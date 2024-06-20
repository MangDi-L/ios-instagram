//
//  Post.swift
//  Instagram
//
//  Created by mangdi on 6/14/24.
//

import Foundation
import FirebaseFirestoreInternal

struct Post {
    var caption: String
    var likes: Int
    let imageUrl: String
    let ownerUid: String
    let timestamp: Timestamp
    let postId: String
    var postUser: User?
    var didLike = false
    
    init(postId: String, dictionary: [String: Any]) {
        self.postId = postId
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
