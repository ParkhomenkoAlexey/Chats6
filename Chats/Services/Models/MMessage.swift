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
    let id: String?
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        return .text(content)
    }
    
    init(user: MUser, content: String) {
        sender = Sender(senderId: user.identifier, displayName: user.username)
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    var representation: [String : Any] {
        let rep: [String : Any] = [
          "created": sentDate,
          "senderID": sender.senderId,
          "senderName": sender.displayName,
          "content": content
        ]
        return rep
    }

    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}
