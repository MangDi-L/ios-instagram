//
//  Constants.swift
//  Instagram
//
//  Created by mangdi on 6/6/24.
//

import Firebase
import FirebaseFirestoreInternal

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_USERNAMES = Firestore.firestore().collection("usernames")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
let COLLECTION_POSTS = Firestore.firestore().collection("posts")
let COLLECTION_NOTIFICATIONS = Firestore.firestore().collection("notifications")
