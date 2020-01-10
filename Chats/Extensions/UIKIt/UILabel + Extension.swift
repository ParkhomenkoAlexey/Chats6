//
//  UILabel + Extension.swift
//  Chats
//
//  Created by Алексей Пархоменко on 05.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.font = font
    }
}
