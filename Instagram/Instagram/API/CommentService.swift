//
//  CommentService.swift
//  Instagram
//
//  Created by mangdi on 6/19/24.
//

import Firebase
import FirebaseFirestoreInternal

struct CommentService {
    static func uploadComment(comment: String, postID: String, userID: String, completion: @escaping(FirestoreCompletion)) {
        let data: [String: Any] = ["uid": userID,
                                   "comment": comment,
                                   "timestamp": Timestamp(date: Date())]
        
        COLLECTION_POSTS.document(postID).collection("comments").addDocument(data: data, completion: completion)
    }
    
    static func fetchComments(forPost postID: String, completion: @escaping([Comment]) -> Void) {
        var comments: [Comment] = []
        let query = COLLECTION_POSTS.document(postID).collection("comments").order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    var comment = Comment(dictionary: data)
                    comments.append(comment)
                }
            })
            
            for (num, comment) in comments.enumerated() {
                UserService.fetchUser(uid: comment.uid) { user in
                    comments[num].user = user
                    
                    if comment == comments.last {
                        completion(comments)
                    }
                }
            }
        }
    }
}
