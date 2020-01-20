//
//  MMessage.swift
//  Chats
//
//  Created by Алексей Пархоменко on 20.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

struct MMessage: Decodable, Hashable {
    let content: String
    let senderName: String
    
    
    let identifier = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
