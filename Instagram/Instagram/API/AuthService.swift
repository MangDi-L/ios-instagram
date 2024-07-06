//
//  AuthService.swift
//  Instagram
//
//  Created by mangdi on 6/3/24.
//

import UIKit
import Firebase

enum AuthServiceError: String, Error {
    case emailaddressDuplicate = "The email address is already in use by another account."
    case fullnameDuplicate = "The fullname is already in use by another account."
    case usernameDuplicate = "The username is already in use by another account."
}

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static func logUserIn(withEmail email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }
    }
    
    static func registerUser(withCredential credentials: AuthCredentials, completion: @escaping (Result<(), Error>) -> Void) {
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { authDataResult, error in
            if let error = error {
                print("DEBUG: Failed to register user \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            ImageUploader.uploadImage(image: credentials.profileImage) { imageUrl in
                guard let uid = authDataResult?.user.uid else { return }
                
                let data: [String: Any] = ["email": credentials.email,
                                           "fullname": credentials.fullname,
                                           "profileImageUrl": imageUrl,
                                           "uid": uid,
                                           "username": credentials.username]
                
                // users컬렉션에 문서 추가
                COLLECTION_USERS.document(uid).setData(data) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        
                        deleteCurrentUser { error in
                            if let error = error {
                                print(error.localizedDescription)
                                completion(.failure(error))
                                return
                            }
                        }
                        completion(.failure(error))
                        return
                    }
                    
                    // usernames컬렉션에 문서 추가
                    COLLECTION_USERNAMES.document(credentials.username).setData(["uid": uid]) { error in
                        if let error = error {
                            print(error.localizedDescription)
                            completion(.failure(error))
                            return
                        }
                        
                        completion(.success(()))
                    }
                }
            }
        }
    }
    
    static func resetPassword(withEmail email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset (withEmail: email, completion: completion)
    }
    
    static func deleteCurrentUser(completion: @escaping (Error?) -> Void) {
        let user = Auth.auth().currentUser
        user?.delete(completion: completion)
    }
}
