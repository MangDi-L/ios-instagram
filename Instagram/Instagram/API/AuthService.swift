//
//  AuthService.swift
//  Instagram
//
//  Created by mangdi on 6/3/24.
//

import UIKit
import Firebase

enum AuthServiceError: String, Error {
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
    static func logUserIn(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredential credentials: AuthCredentials, completion: @escaping (Result<(), Error>) -> Void) {
        checkupNamesDuplicate(fullname: credentials.fullname, username: credentials.username) { result in
            switch result {
            case .success:
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
                        
                        COLLECTION_USERS.document(uid).setData(data) { error in
                            completion(.success(()))
                        }
                    }
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    static func resetPassword(withEmail email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset (withEmail: email, completion: completion)
    }
    
    static func checkupNamesDuplicate(fullname: String, username: String, completion: @escaping (Result<Void, AuthServiceError>) -> Void) {
        COLLECTION_USERS.getDocuments { querySnapshot, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
            }
            
            guard let snapshot = querySnapshot else { return }
            
            if snapshot.documents.isEmpty { completion(.success(())) }
            
            let users = snapshot.documents.map { User(dictionary: $0.data()) }
            let fullnames = users.map { $0.fullname }
            let usernames = users.map { $0.username }
            
            if fullnames.contains(fullname) {
                completion(.failure(.fullnameDuplicate))
            } else if usernames.contains(username) {
                completion(.failure(.usernameDuplicate))
            } else {
                completion(.success(()))
            }
            
        }
    }
}
