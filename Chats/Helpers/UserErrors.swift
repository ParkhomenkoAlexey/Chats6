//
//  UserErrors.swift
//  Chats
//
//  Created by Алексей Пархоменко on 23.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation

enum UserError {
    case notFilled
    case photoNotExist
    case cantGetUserInfo
    case cantUnwrapToMUser
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
            case .photoNotExist:
            return NSLocalizedString("Пользователь не выбрал фотографию", comment: "")
        case .cantGetUserInfo:
            return NSLocalizedString("Невозможно загрузить информацию о User из Firebase", comment: "")
        case .cantUnwrapToMUser:
            return NSLocalizedString("Невозможно конвертировать MUser из User", comment: "")
        }
    }
}
