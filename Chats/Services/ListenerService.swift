//
//  ListenerService.swift
//  Chats
//
//  Created by Алексей Пархоменко on 24.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

class ListenerService {
    
    static let shared = ListenerService()
    
    private let db = Firestore.firestore()
    private var usersRef: CollectionReference {
      return db.collection("users")
    }
    
    func usersObserve(users: [MUser], currentUser: MUser, completion: @escaping (Result<[MUser], Error>) -> Void) -> ListenerRegistration? {
        var users = users
        let usersListener = usersRef.addSnapshotListener({ (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                guard let user = MUser(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    guard !users.contains(user) else { return }
                    guard user != currentUser else { return }
                    users.append(user)
                case .modified:
                    guard let index = users.firstIndex(of: user) else { return }
                    users[index] = user
                case .removed:
                    guard let index = users.firstIndex(of: user) else { return }
                    users.remove(at: index)
                }
            }
            completion(.success(users))
        })
        return usersListener
    }
}


//private var waitingChatsListener: ListenerRegistration?
//private var waitingChatsMessagesListener: ListenerRegistration?
//private var waitingChatsReference: CollectionReference {
//  return Firestore.firestore().collection(["users", currentUser.identifier, "waitingChats"].joined(separator: "/"))
//}

//deinit {
//    waitingChatsListener?.remove()
//}

//waitingChatsListener = waitingChatsReference.addSnapshotListener({ [weak self] (querySnapshot, error) in
//    guard let snapshot = querySnapshot else { print("Error fetching snapshots: \(error!)")
//        return }
//    
//    snapshot.documentChanges.forEach { [weak self] diff in
//        guard var waitingChat = MChat(document: diff.document) else { return }
//        
//        switch diff.type {
//        case .added:
//            guard !(self?.whaitingChats.contains(waitingChat))! else { return }
//            self?.whaitingChats.append(waitingChat)
//        case .modified:
//            guard let index = self?.whaitingChats.firstIndex(of: waitingChat) else { return }
//            self?.whaitingChats[index] = waitingChat
//        case .removed:
//            guard let index = self?.whaitingChats.firstIndex(of: waitingChat) else { return }
//            self?.whaitingChats.remove(at: index)
//        } // switch
//        
//        self?.waitingChatsMessagesListener = Firestore.firestore().collection(["users", self!.currentUser.identifier, "waitingChats", waitingChat.friendIdentifier, "messages"].joined(separator: "/")).addSnapshotListener({ (querySnapshot, error) in
//            guard let snapshot = querySnapshot else { print("Error fetching snapshots: \(error!)")
//                return }
//            
//            snapshot.documentChanges.forEach { (diff) in
//                guard let message = MMessage(document: diff.document) else {
//                    return }
//                waitingChat.lastMessageContent = message.content
//                print(waitingChat.lastMessageContent)
//                
//                
//            }
//            
//        }) // waitingChatsMessagesListener
//    }
//}) // waitingChatsListener


