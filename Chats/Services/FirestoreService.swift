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
    
    private let db = Firestore.firestore()
    
    private var currentUser: MUser!
    
    private var usersRef: CollectionReference {
      return db.collection("users")
    }
    
    private var waitingChatsRef: CollectionReference {
      return db.collection(["users", currentUser.identifier, "waitingChats"].joined(separator: "/"))
    }
    
    private var activeChatsRef: CollectionReference {
      return db.collection(["users", currentUser.identifier, "activeChats"].joined(separator: "/"))
    }
    
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
    
    // for SceneDelegate
    func getUserData(user: User, completion: @escaping (Result<MUser, Error>) -> Void) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                guard let muser = MUser(document: document) else {
                    completion(.failure(UserError.cantUnwrapToMUser))
                  return
                }
                self.currentUser = muser
                completion(.success(muser))
            } else {
                completion(.failure(UserError.cantGetUserInfo))
            }
        }
    } // getUserData
    
    
    // for ProfileViewController
    func createWaitingChat(message: String, receiver: MUser, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = db.collection(["users", receiver.identifier, "waitingChats"].joined(separator: "/"))
        let messagesRef = reference.document(self.currentUser.identifier).collection("messages")
        
        let message = MMessage(user: currentUser, content: message)
        let chat = MChat(friendUsername: currentUser.username,
                         friendAvatarStringURL: currentUser.avatarStringURL,
                         friendIdentifier: currentUser.identifier, lastMessageContent: message.content)
        
        
        reference.document(currentUser.identifier).setData(chat.representation, completion: { (error) in
            if let error = error {
              completion(.failure(error))
              return
            }
            messagesRef.addDocument(data: message.representation, completion: { (error) in
                if let error = error {
                  completion(.failure(error))
                  return
                }
                completion(.success(Void()))
            })
        })
    }
    
    // for ListViewController
    func deleteWaitingChat(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        waitingChatsRef.document(chat.friendIdentifier).delete(completion: { (error) in
            if let error = error { completion(.failure(error))
              return }
            self.deleteMessages(chat: chat, completion: completion)
        })
    }
    
    // 2
    // for deleteWaitingChat func
    func deleteMessages(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = waitingChatsRef.document(chat.friendIdentifier).collection("messages")
        
        getWaitingChatMessages(chat: chat) { (result) in
            switch result {
            case .success(let messages):
                for message in messages {
                    guard let documentId = message.id else { return }
                    let messageRef = reference.document(documentId)
                    messageRef.delete { (error) in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(Void()))
                    }
                    
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 1
    func getWaitingChatMessages(chat: MChat, completion: @escaping (Result<[MMessage], Error>) -> Void) {
        var messages = [MMessage]()
        let reference = waitingChatsRef.document(chat.friendIdentifier).collection("messages")
        reference.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            for document in querySnapshot!.documents {
                guard let message = MMessage(document: document) else {
                completion(.failure(MessageError.cantUnwrapToMMessage))
                return }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
    
    
    // for ListViewController
    func changeToActive(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        getWaitingChatMessages(chat: chat) { (result) in
            switch result {
            case .success(let messages):
                self.deleteWaitingChat(chat: chat) { (result) in
                    switch result {
                    case .success:
                        self.createActiveChat(chat: chat, messages: messages, completion: completion)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 3
    func createActiveChat(chat: MChat, messages: [MMessage], completion: @escaping (Result<Void, Error>) -> Void) {
        let messageRef = activeChatsRef.document(chat.friendIdentifier).collection("messages")
        
        activeChatsRef.document(chat.friendIdentifier).setData(chat.representation) { (error) in
            if let error = error {
              completion(.failure(error))
              return
            }
            for message in messages {
                messageRef.addDocument(data: message.representation) { (error) in
                    if let error = error {
                      completion(.failure(error))
                      return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
}

