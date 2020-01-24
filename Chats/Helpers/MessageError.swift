//
//  MessageError.swift
//  Chats
//
//  Created by Алексей Пархоменко on 24.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation

enum MessageError {
    case cantUnwrapToMMessage
}

extension MessageError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cantUnwrapToMMessage:
            return NSLocalizedString("Невозможно конвертировать MMesage из Data()", comment: "")
        }
    }
}
