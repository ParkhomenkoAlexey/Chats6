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
    
     init(label: UILabel, button: UIButton) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        self.addSubview(button)
        
        // label
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
    ])
        
        // button
        button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        // чтобы высчитывался размер у self view
        bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
