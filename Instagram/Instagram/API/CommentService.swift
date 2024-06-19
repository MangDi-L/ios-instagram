//
//  CommentService.swift
//  Instagram
//
//  Created by mangdi on 6/19/24.
//

import Firebase

struct CommentService {
    static func uploadComment(comment: String, postID: String, userID: String, completion: @escaping(FirestoreCompletion)) {
        let data: [String: Any] = ["uid": userID,
                                   "comment": comment,
                                   "timestamp": Timestamp(date: Date())]
        
        COLLECTION_POSTS.document(postID).collection("comments").addDocument(data: data, completion: completion)
    }
}
