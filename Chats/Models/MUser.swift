//
//  MUser.swift
//  Chats
//
//  Created by Алексей Пархоменко on 10.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

struct MUser: Decodable, Hashable {
    var username: String
    var avatarStringURL: String
    var sex: String
}
