//
//  PostService.swift
//  Instagram
//
//  Created by mangdi on 6/14/24.
//

import UIKit
import Firebase
import FirebaseFirestoreInternal

enum PostServiceError: String, Error {
    case contentsEmpty = "The received contents do not exist."
}

struct PostService {
    static func uploadPost(caption: String, image: UIImage, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data: [String: Any] = ["caption": caption,
                                       "timestamp": Timestamp(date: Date()),
                                       "likes": 0,
                                       "imageUrl": imageUrl,
                                       "ownerUid": uid]
            
            let docRef = COLLECTION_POSTS.addDocument(data: data, completion: completion)
            
            UserService.updateUserFeedAfterPost(postId: docRef.documentID)
        }
    }
    
    // 피드컨트롤러에서 모든 유저의 포스트내역 가져오는 코드
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            var posts: [Post] = []
            
            // 모든 포스트들에 유저정보 넣는 작업
            documents.forEach { document in
                var post = Post(postId: document.documentID, dictionary: document.data())
                posts.append(post)
                
                if document == documents.last {
                    posts.sort { post1, post2 in
                        return post1.timestamp.seconds > post2.timestamp.seconds
                    }
                    
                    for (index, post) in posts.enumerated() {
                        UserService.fetchUser(uid: post.ownerUid) { user in
                            posts[index].postUser = user
                            completion(posts)
                        }
                    }
                }
            }
        }
    }
    
    // 어떤 유저의 프로필화면에서 포스트내역 가져오는 코드
    static func fetchPosts(forUser uid: String, completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS
            .whereField("ownerUid", isEqualTo: uid)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents,
                      let firstDocument = documents.first else { return }
                var posts: [Post] = []
                
                let post = Post(postId: firstDocument.documentID, dictionary: firstDocument.data())
                
                // 한사람의 유저정보만 가져와도 되기때문에 한번의 호출로 가져온 유저 정보를 모든 post에 담아주기
                UserService.fetchUser(uid: post.ownerUid) { user in
                    let postUser = user
                    
                    documents.forEach { documentSnapshot in
                        var post = Post(postId: documentSnapshot.documentID, dictionary: documentSnapshot.data())
                        post.postUser = postUser
                        posts.append(post)
                        
                        if documentSnapshot == documents.last {
                            posts.sort { post1, post2 in
                                return post1.timestamp.seconds > post2.timestamp.seconds
                            }
                            completion(posts)
                        }
                    }
                }
            }
    }
    
    static func fetchPost(id: String, isNeedPostUser: Bool, completion: @escaping(Post) -> Void) {
        COLLECTION_POSTS.document(id).getDocument { snapshot, _ in
            guard let document = snapshot,
                  let data = document.data() else { return }
            var post = Post(postId: document.documentID, dictionary: data)
            
            if isNeedPostUser {
                UserService.fetchUser(uid: post.ownerUid) { user in
                    post.postUser = user
                    completion(post)
                }
            } else {
                completion(post)
            }
        }
    }
    
    static func fetchLikedPost(from: User, completion: @escaping([Post]) -> Void) {
        var posts: [Post] = []
        
        COLLECTION_USERS.document(from.uid).collection("user-likes").getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            documents.forEach { document in
                fetchPost(id: document.documentID, isNeedPostUser: true) { post in
                    posts.append(post)
                    completion(posts)
                }
            }
        }
    }
    
    static func likePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes + 1])
        
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).setData([:]) { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).setData([:], completion: completion)
        }
    }
    
    static func unlikePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard post.likes > 0 else { return }
        
        COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes - 1])
        
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).delete { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).delete(completion: completion)
        }
    }
    
    static func checkIfUserLikedPost(post: Post, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).getDocument { snapshot, _ in
            guard let didLike = snapshot?.exists else { return }
            completion(didLike)
        }
    }
    
    static func fetchUserFeedPosts(completion: @escaping(Result<[Post], PostServiceError>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var posts: [Post] = []
        
        COLLECTION_USERS.document(uid).collection("user-feed").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            if documents.isEmpty {
                completion(.failure(.contentsEmpty))
            }
            
            for (index, document) in documents.enumerated() {
                fetchPost(id: document.documentID, isNeedPostUser: true) { post in
                    posts.append(post)
                    completion(.success(posts))
                }
            }
        }
    }
    
    static func modifyPost(post: Post, completion: @escaping (Error?) -> Void) {
        let dictionary = post.dictionary
        
        COLLECTION_POSTS.document(post.postId).updateData(dictionary, completion: completion)
    }
    
    static func deletePost(post: Post, completion: @escaping () -> Void) {
        // users - user-likes 삭제
        // 삭제
        
        COLLECTION_POSTS.document(post.postId).collection("post-likes").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            // post를 like한사람들의 uid를 가지고 user-likes중 해당 postID 삭제
            documents.forEach { document in
                COLLECTION_USERS.document(document.documentID).collection("user-likes").document(post.postId).delete()
            }
        }
        
        COLLECTION_POSTS.document(post.postId).delete { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            completion()
        }
        
        // posts - 하위comments컬렉션 삭제
        // posts - 하위post-likes컬렉션 삭제
        // users - user-feed컬렉션의 postID 문서 삭제
        // 위 세가지는 Cloud Function 이용해서 해결해야함
        // 삭제는 필드만 삭제가되서 컬렉션 및 문서 자체를 삭제하려면 Cloud Function 이용..
    }
}
