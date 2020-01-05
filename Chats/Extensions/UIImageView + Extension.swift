//
//  UIImageView + Extension.swift
//  Chats
//
//  Created by Алексей Пархоменко on 05.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    convenience init(image: UIImage, contentMode: UIView.ContentMode) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.image = image
        self.contentMode = contentMode
    }
}
