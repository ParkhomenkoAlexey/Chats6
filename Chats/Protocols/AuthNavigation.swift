//
//  AuthNavigation.swift
//  Chats
//
//  Created by Алексей Пархоменко on 23.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

protocol AuthNavigation: class {
    func toLoginVC()
    func toSignUpVC()
}
