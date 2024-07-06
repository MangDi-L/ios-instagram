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
        
        // 자동으로 이메일중복 검사
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { authDataResult, error in
            if let error = error as? NSError,
               let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                print("DEBUG: Failed to register user \(error.localizedDescription)")
                switch errorCode {
                case .emailAlreadyInUse:
                    completion(.failure(AuthServiceError.emailaddressDuplicate))
                default:
                    completion(.failure(error))
                }

                return
            }
            
            ImageUploader.uploadImage(image: credentials.profileImage) { imageUrl in
                guard let uid = authDataResult?.user.uid else { return }
                
                let data: [String: Any] = ["email": credentials.email,
                                           "fullname": credentials.fullname,
                                           "profileImageUrl": imageUrl,
                                           "uid": uid,
                                           "username": credentials.username]
                
                // users컬렉션에 문서 추가 및 username중복 검사, 중복시 error반환(Firestore rule)
                COLLECTION_USERS.document(uid).setData(data) { error in
                    if let setDataError = error {
                        print(setDataError.localizedDescription)
                        
                        deleteCurrentUser { error in
                            if let deleteError = error {
                                print(deleteError.localizedDescription)
                                completion(.failure(deleteError))
                                return
                            }
                            
                            completion(.failure(AuthServiceError.usernameDuplicate))
                            return
                        }
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
