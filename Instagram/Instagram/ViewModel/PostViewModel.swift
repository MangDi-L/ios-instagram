//
//  PostViewModel.swift
//  Instagram
//
//  Created by mangdi on 6/14/24.
//

import Foundation

struct PostViewModel {
    let post: Post
    
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
