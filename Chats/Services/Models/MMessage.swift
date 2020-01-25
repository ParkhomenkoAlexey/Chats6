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
import FirebaseFirestore

struct MMessage: Hashable, MessageType {
    
    let content: String
    var sender: SenderType
    let id: String?
    var sentDate: Date
    
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
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let sentDate = data["created"] as? Timestamp else {
          return nil
        }
        guard let senderId = data["senderID"] as? String else {
          return nil
        }
        guard let senderDisplayName = data["senderName"] as? String else {
          return nil
        }
        guard let content = data["content"] as? String else {
          return nil
        }
        
//        self.sentDate = sentDate
        self.sentDate = sentDate.dateValue()
        self.sender = Sender(senderId: senderId, displayName: senderDisplayName)
        self.content = content
        self.id = document.documentID
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

extension MMessage: Comparable {

  static func < (lhs: MMessage, rhs: MMessage) -> Bool {
    return lhs.sentDate < rhs.sentDate
  }
}
