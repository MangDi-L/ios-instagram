//
//  User.swift
//  Instagram
//
//  Created by mangdi on 6/6/24.
//

import Foundation
import Firebase

struct User {
    let email: String
    var fullname: String
    var profileImageUrl: String
    let uid: String
    var username: String
    
    var isFollowed = false
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    var stats: UserStats?
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
    }
}

struct UserStats {
    let following: Int
    let followers: Int
    let posts: Int
}
