//
//  UserService.swift
//  Instagram
//
//  Created by mangdi on 6/6/24.
//

import Firebase

struct UserService {
    static func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { documentSnapshot, error in
            print(documentSnapshot?.data())
        }
    }
}
