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
                                       "ownerUrl": uid]
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
}
