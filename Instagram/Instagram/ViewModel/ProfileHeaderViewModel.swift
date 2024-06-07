//
//  ProfileHeaderViewModel.swift
//  Instagram
//
//  Created by mangdi on 6/6/24.
//

import Foundation

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
}
