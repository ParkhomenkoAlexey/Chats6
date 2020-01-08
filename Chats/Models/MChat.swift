//
//  MChat.swift
//  Chats
//
//  Created by Алексей Пархоменко on 09.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

struct MChat: Decodable, Hashable {
    let friendName: String
    let friendImage: String
    let lastMessage: String
}
