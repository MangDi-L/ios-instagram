//
//  PostViewModel.swift
//  Instagram
//
//  Created by mangdi on 6/14/24.
//

import UIKit

struct PostViewModel {
    var post: Post
    
    var postImageUrl: URL? {
        return URL(string: post.imageUrl)
    }
    
    var caption: String {
        return post.caption
    }
    
    var likes: Int {
        return post.likes
    }
    
    var likesLabelText: String {
        if post.likes != 1 {
            return"\(post.likes) likes"
        } else {
            return"\(post.likes) like"
        }
    }
    
    var likeButtonTintColor: UIColor {
        return post.didLike ? .red : .black
    }
    
    var likeButtonImage: UIImage {
        return post.didLike ? #imageLiteral(resourceName: "like_selected") : #imageLiteral(resourceName: "like_unselected")
    }
    
    var profileImageUrl: URL? {
        return URL(string: post.postUser?.profileImageUrl ?? "")
    }
    
    var username: String {
        return post.postUser?.username ?? ""
    }
    
    init(post: Post) {
        self.post = post
    }
}
