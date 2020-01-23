//
//  MChat.swift
//  Chats
//
//  Created by Алексей Пархоменко on 09.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

struct MChat: Hashable {
    var friendUsername: String
    var friendAvatarStringURL: String
    var friendIdentifier: String
    var lastMessageContent: String // только из-за отображения изображений на экране ListVC
    
    init(friendUsername: String, friendAvatarStringURL: String,
         friendIdentifier: String, lastMessageContent: String) {
        self.friendUsername = friendUsername
        self.friendAvatarStringURL = friendAvatarStringURL
        self.friendIdentifier = friendIdentifier
        self.lastMessageContent = lastMessageContent
    }
    
    var representation: [String : Any] {
        var rep = ["friendUsername": friendUsername]
        rep["friendAvatarStringURL"] = friendAvatarStringURL
        rep["friendIdentifier"] = friendIdentifier
        rep["lastMessage"] = lastMessageContent
        return rep
    }
}
