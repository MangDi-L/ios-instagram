//
//  UserService.swift
//  Instagram
//
//  Created by mangdi on 6/6/24.
//

import Firebase

typealias FirestoreCompletion = (Error?) -> Void

struct UserService {
    static func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { documentSnapshot, error in
            if let error = error {
                print("DEBUG: failed to get userdata")
            }
            
            guard let dictionary = documentSnapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            
            completion(user)
        }
    }
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        COLLECTION_USERS.getDocuments { querySnapshot, error in
            guard let snapshot = querySnapshot else { return }
            
            let users = snapshot.documents.map { User(dictionary: $0.data()) }
            completion(users)
        }
    }
    
    static func follow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // 1. 자신의 following컬렉션에 상대 프로필주인uid를 추가한다.
        // 2. 상대 follower컬렉션에 자기 자신의 uid를 추가한다.
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).setData([:]) { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).setData([:], completion: completion)
        }
    }
    
    static func unfollow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).delete { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
        }
    }
}
