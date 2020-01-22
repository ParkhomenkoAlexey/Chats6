//
//  MMessage.swift
//  Chats
//
//  Created by Алексей Пархоменко on 20.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

struct MMessage: Hashable, MessageType {
    
    let content: String
    var sentDate: Date
    var sender: SenderType
    
    var messageId: String {
        return identifier.uuidString
    }
    
    var kind: MessageKind {
        return .text(content)
    }
    
    init(user: UsersController.MUser, content: String) {
        sender = Sender(senderId: user.identifier.uuidString, displayName: user.username)
        self.content = content
        sentDate = Date()
    }
    
    let identifier = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
