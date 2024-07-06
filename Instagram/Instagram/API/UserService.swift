//
//  UserService.swift
//  Instagram
//
//  Created by mangdi on 6/6/24.
//

import Firebase

enum UserServiceError: String, Error {
    case sameUsername = "It's a same username"
    case usernameDuplicate = "The username is already in use by another account."
}

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
    
    // 36)
    static func fetchUser(uid: String, completion: @escaping(User) -> Void) {
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
    
    static func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).getDocument { snapshot, error in
            guard let isFollowed = snapshot?.exists else { return }
            completion(isFollowed)
        }
    }
    
    // 프로필에 표시할 팔로워, 팔로잉, 포스트 갖고오기
    static func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void) {
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, error in
            let followers = snapshot?.documents.count ?? 0
            
            COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { snapshot, error in
                let following = snapshot?.documents.count ?? 0
                
                COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, error in
                    let posts = snapshot?.documents.count ?? 0
                    completion(UserStats(following: following, followers: followers, posts: posts))
                }
            }
        }
    }
    
    // 팔로우 이후 user-feed 컬렉션의 내용 업데이트
    static func updateUserFeedAfterFollowing(opponentUid: String, didFollow: Bool) {
        guard let myUid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_POSTS.whereField("ownerUid", isEqualTo: opponentUid)
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            let docIDs = documents.map { $0.documentID }
            
            docIDs.forEach { id in
                if didFollow {
                    COLLECTION_USERS.document(myUid).collection("user-feed").document(id).setData([:])
                } else {
                    COLLECTION_USERS.document(myUid).collection("user-feed").document(id).delete()
                }
            }
        }
    }
    
    // 자신을 팔로우 한 상대방에게 내가 게시글을 올릴때마다 갱신될수있도록 그리고 내 게시글도 볼수있도록
    // 66) 이 부분은 비효율적이며 서버에서 처리할내용을 클라이언트가 처리할 경우의 코드다. 자세한 내용은 결제...
    static func updateUserFeedAfterPost(postId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // 날 팔로우 하는사람들의 목록을 가지고
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            // 날 팔로우 하는사람들의 user-feed 항목에 postID를 넣는다.
            documents.forEach { document in
                COLLECTION_USERS.document(document.documentID).collection("user-feed").document(postId).setData([:])
            }
            
            // 내 user-feed에 내가 추가한 postId를 넣는다.
            COLLECTION_USERS.document(uid).collection("user-feed").document(postId).setData([:])
        }
    }
    
    static func updateUserProfileImage(user: User, image: UIImage, completion: @escaping(User) -> Void) {
        ImageUploader.uploadImage(image: image) { imageUrl in
            var user = user
            user.profileImageUrl = imageUrl
            let dictionary = user.dictionary
            COLLECTION_USERS.document(user.uid).updateData(dictionary) { error in
                completion(user)
            }
        }
    }
    
    static func updateUserProfileName(user: User, type: ProfileNameType, name: String, completion: @escaping(Result<User, Error>) -> Void) {
        var userData = user
        
        switch type {
        case .fullname:
            userData.fullname = name
        case .username:
            userData.username = name
        }
        
        // 기존 username과 똑같을경우 리턴
        if type == .username && userData.username == user.username {
            completion(.failure(UserServiceError.sameUsername))
            return
        }
        
        let dictionary = userData.dictionary
        
        if type == .fullname {
            
            // fullname 갱신 시작
            COLLECTION_USERS.document(user.uid).updateData(dictionary) { error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                
                completion(.success(userData))
            }
            return
        }
        
        // usernames컬렉션에 새로운 username이 중복되는지 확인
        COLLECTION_USERNAMES.document(userData.username).getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            // 중복된 데이터가 있다면 실패completion호출 및 리턴
            if snapshot.exists {
                completion(.failure(UserServiceError.usernameDuplicate))
                return
            }
            
            // 중복된 데이터가 없다면
            // usernames컬렉션의 기존 username삭제
            COLLECTION_USERNAMES.document(user.username).delete { error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                
                // usernames컬렉션에 새로바꾼 username추가
                COLLECTION_USERNAMES.document(userData.username).setData(["uid": userData.uid]) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(.failure(error))
                        return
                    }
                    
                    // username 갱신 시작
                    COLLECTION_USERS.document(user.uid).updateData(dictionary) { error in
                        if let error = error {
                            print(error.localizedDescription)
                            completion(.failure(error))
                            return
                        }
                        
                        completion(.success(userData))
                    }
                }
                
            }
        }
    }
}
