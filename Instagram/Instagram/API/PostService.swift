//
//  PostService.swift
//  Instagram
//
//  Created by mangdi on 6/14/24.
//

import UIKit
import Firebase
import FirebaseFirestoreInternal

struct PostService {
    static func uploadPost(caption: String, image: UIImage, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data: [String: Any] = ["caption": caption,
                                       "timestamp": Timestamp(date: Date()),
                                       "likes": 0,
                                       "imageUrl": imageUrl,
                                       "ownerUid": uid]
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
    
    // 피드컨트롤러에서 모든 유저의 포스트내역 가져오는 코드
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            var posts: [Post] = []
            
            // 모든 포스트들에 유저정보 넣는 작업
            documents.forEach { documentSnapshot in
                var post = Post(postId: documentSnapshot.documentID, dictionary: documentSnapshot.data())
                
                UserService.fetchUser(uid: post.ownerUid) { user in
                    post.postUser = user
                    posts.append(post)
                    
                    if documentSnapshot == documents.last {
                        completion(posts)
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
}
