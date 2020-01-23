//
//  StorageService.swift
//  Chats
//
//  Created by Алексей Пархоменко on 23.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import FirebaseStorage
import Firebase

class StorageService {
    static let shared = StorageService()

    let storageRef = Storage.storage().reference()
    private var avatarsRef: StorageReference {
        storageRef.child("avatars")
    }
    
    func upload(photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let imageData = photo.jpegData(compressionQuality: 0.5) else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        avatarsRef.child(uid).putData(imageData, metadata: metadata) { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            self.avatarsRef.child(uid).downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadURL))
            }
        }
    }
}
