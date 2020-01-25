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

struct ImageItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

struct MMessage: Hashable, MessageType {
    
    let content: String
    var sender: SenderType
    let id: String?
    var sentDate: Date
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    
    
    var kind: MessageKind {
        
        if let image = image {
            let mediaItem = ImageItem(url: nil, image: nil, placeholderImage: image, size: image.size)
            return .photo(mediaItem)
        } else {
          return .text(content)
        }

    }
    
    var image: UIImage? = nil
    var downloadURL: URL? = nil
    
    init(user: MUser, content: String) {
        sender = Sender(senderId: user.identifier, displayName: user.username)
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init(user: MUser, image: UIImage) {
      sender = Sender(senderId: user.identifier, displayName: user.username)
      self.image = image
      content = ""
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
        
        self.id = document.documentID
        self.sentDate = sentDate.dateValue()
        self.sender = Sender(senderId: senderId, displayName: senderDisplayName)
        
        if let content = data["content"] as? String {
            self.content = content
            downloadURL = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            self.content = ""
        } else {
            return nil
        }
        
    }
    
    var representation: [String : Any] {
        var rep: [String : Any] = [
          "created": sentDate,
          "senderID": sender.senderId,
          "senderName": sender.displayName
        ]
        
        if let url = downloadURL {
          rep["url"] = url.absoluteString
        } else {
          rep["content"] = content
        }
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
