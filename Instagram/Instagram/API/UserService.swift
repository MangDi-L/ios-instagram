//
//  UserService.swift
//  Instagram
//
//  Created by mangdi on 6/6/24.
//

import Firebase

struct UserService {
    static func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { documentSnapshot, error in
            if let error = error {
                print("DEBUG: failed to get userdata")
            }
            
            guard let dictionary = documentSnapshot?.data(),
                  let email = dictionary["email"] as? String,
                  let fullname = dictionary["fullname"] as? String,
                  let profileImageUrl = dictionary["profileImageUrl"] as? String,
                  let uid = dictionary["uid"] as? String,
                  let username = dictionary["username"] as? String else { return }
            
            let user = User(email: email, fullname: fullname, profileImageUrl: profileImageUrl, uid: uid, username: username)
            completion(user)
        }
    }
}
