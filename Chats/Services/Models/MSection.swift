//
//  MSection.swift
//  Chats
//
//  Created by Алексей Пархоменко on 09.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

struct MSection: Decodable, Hashable {
    let type: String
    let title: String
    let items: [MChat]
}
