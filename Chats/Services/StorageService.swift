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
    
    private var chatsRef: StorageReference {
        storageRef.child("chats")
    }
    
    private var currentUser: MUser {
        return FirestoreService.shared.currentUser
    }
    
    func upload(photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = photo.jpegData(compressionQuality: 0.5) else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        avatarsRef.child(currentUser.identifier).putData(imageData, metadata: metadata) { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            self.avatarsRef.child(self.currentUser.identifier).downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadURL))
            }
        }
    }
    
    func uploadImageMessage(photo: UIImage, to chat: MChat, completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let scaledImage = photo.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else {
          return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        chatsRef.child(chat.friendAvatarStringURL).child(imageName).putData(imageData, metadata: metadata) { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            
            self.chatsRef.child(chat.friendAvatarStringURL).child(imageName).downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadURL))
            }
        }
    }
    
    func downloadImage(url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)

        ref.getData(maxSize: megaByte) { data, error in
          guard let imageData = data else {
            completion(.failure(error!))
            return
          }
          
            completion(.success(UIImage(data: imageData)))
        }
    }
}
