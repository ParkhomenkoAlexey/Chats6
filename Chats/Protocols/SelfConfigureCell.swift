//
//  SelfConfigureCell.swift
//  Chats
//
//  Created by Алексей Пархоменко on 09.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure<U: Decodable>(with value: U)
}
