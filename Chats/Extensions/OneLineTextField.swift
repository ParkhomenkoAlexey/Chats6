//
//  UITextField + Extension.swift
//  Chats
//
//  Created by Алексей Пархоменко on 06.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

class OneLineTextField: UITextField {
    
    convenience init(font: UIFont? = .avenir20(), borderStyle: UITextField.BorderStyle = .none) {
        self.init()
        self.font = font
        self.borderStyle = borderStyle
        self.translatesAutoresizingMaskIntoConstraints = false
        
        //Mark: Setup Bottom-Border
        var bottomBorder = UIView()
        bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBorder.backgroundColor = .textFieldLight()
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomBorder)
        //Mark: Setup Anchors
        bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomBorder.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bottomBorder.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true // Set Border-Strength
    }
}
