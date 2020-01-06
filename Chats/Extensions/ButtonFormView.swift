//
//  UIView + Extension.swift
//  Chats
//
//  Created by Алексей Пархоменко on 05.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

class ButtonFormView: UIView {
    
    convenience init(label: UILabel, button: UIButton) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        self.addSubview(button)
        
        // label
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        
        // button
        button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        // чтобы высчитывался размер у self view
        bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
    }
}
