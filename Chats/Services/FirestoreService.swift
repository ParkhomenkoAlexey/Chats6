//
//  FirestoreService.swift
//  Chats
//
//  Created by Алексей Пархоменко on 22.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    private let auth = Auth.auth()
    
    let usersRef = Firestore.firestore().collection("users")
    
    func saveProfileWith(id: String?, email: String?, username: String?, avatarImage: UIImage?, description: String?, sex: String?, completion: @escaping (Result<MUser, Error>) -> Void) {
        
        guard Validators.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        guard avatarImage != #imageLiteral(resourceName: "avatar") else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        
        var muser = MUser.init(username: username!,
                                              avatarStringURL: "not exist",
                                              email: email!,
                                              description: description!,
                                              sex: sex!,
                                              identifier: id!)
        
        StorageService.shared.upload(photo: avatarImage!) { (result) in
            switch result {
            case .success(let url):
                muser.avatarStringURL = url.absoluteString
                self.usersRef.document(muser.identifier).setData(muser.representation) { (error) in
                    if let err = error {
                        completion(.failure(err))
                    } else {
                        completion(.success(muser))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        } // StorageService
    } // saveProfileWith
    
    func getUserData(user: User, completion: @escaping (Result<MUser, Error>) -> Void) {
        let docRef = Firestore.firestore().collection("users").document(user.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                guard let muser = MUser(document: document) else {
                    completion(.failure(UserError.cantUnwrapToMUser))
                  return
                }
                completion(.success(muser))
            } else {
                completion(.failure(UserError.cantGetUserInfo))
            }
        }
    } // getUserData
    
//    func getUsers(completion: @escaping (Result<[MUser], Error>) -> Void) {
//        Firestore.firestore().collection("users").getDocuments { (querySnapshot, error) in
//            var users: [MUser] = []
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                for document in querySnapshot!.documents {
//                    if let muser = MUser(document: document) {
//                        users.append(muser)
//                    }
//                }
//                completion(.success(users))
//            }
//        }
//    }
}
