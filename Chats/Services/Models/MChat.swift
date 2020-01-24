//
//  MChat.swift
//  Chats
//
//  Created by Алексей Пархоменко on 09.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

struct MChat: Hashable {
    var friendUsername: String
    var friendAvatarStringURL: String
    var friendIdentifier: String
    var lastMessageContent: String // только из-за отображения изображений на экране ListVC
    var id: String?
    
    init(friendUsername: String, friendAvatarStringURL: String,
         friendIdentifier: String, lastMessageContent: String) {
        self.friendUsername = friendUsername
        self.friendAvatarStringURL = friendAvatarStringURL
        self.friendIdentifier = friendIdentifier
        self.lastMessageContent = lastMessageContent
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let friendUsername = data["friendUsername"] as? String,
            let friendAvatarStringURL = data["friendAvatarStringURL"] as? String,
            let friendIdentifier = data["friendIdentifier"] as? String,
            let lastMessageContent = data["lastMessage"] as? String else {
                return nil
        }
        self.friendUsername = friendUsername
        self.friendAvatarStringURL = friendAvatarStringURL
        self.friendIdentifier = friendIdentifier
        self.lastMessageContent = lastMessageContent
        self.id = document.documentID
    }
    
    var representation: [String : Any] {
        var rep = ["friendUsername": friendUsername]
        rep["friendAvatarStringURL"] = friendAvatarStringURL
        rep["friendIdentifier"] = friendIdentifier
        rep["lastMessage"] = lastMessageContent
        return rep
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendIdentifier)
    }
    
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.friendIdentifier == rhs.friendIdentifier
    }
}
