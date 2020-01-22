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
    
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    func saveProfileWith(username: String?, avatarImage: UIImage?, description: String?, sex: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard Validators.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        guard avatarImage != #imageLiteral(resourceName: "avatar") else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        
        completion(.success(Void()))
        
        let userId = auth.currentUser?.uid
        let userEmail = auth.currentUser?.email
        let user = UsersController.MUser.init(username: username!,
                                              avatarStringURL: "not exist",
                                              email: userEmail!,
                                              description: description!,
                                              sex: sex!,
                                              identifier: userId!)
        ref = db.collection("users").addDocument(data: user.representation) { (error) in
            if let err = error {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
    }
    
    func getUserData() {
        
    }
}
