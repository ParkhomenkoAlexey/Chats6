//
//  InsetableTextField.swift
//  Chats
//
//  Created by Алексей Пархоменко on 20.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}

class InsetableTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        placeholder = "Write something here …"
        font = UIFont.systemFont(ofSize: 14)
        clearButtonMode = .whileEditing
        borderStyle = .none
        layer.cornerRadius = 18
        layer.masksToBounds = true

        
        let image = UIImage(systemName: "smiley")
        
        let imageView = UIImageView(image: image)
        imageView.setImageColor(color: .lightGray)
       
        leftView = imageView
        leftView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
        leftViewMode = .always
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Sent"), for: .normal)
        button.applyGradients(cornerRadius: 10)
        
        rightView = button
        rightView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
        rightViewMode = .always
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)

    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x += -12
        return rect
    }
}

// MARK: - SwiftUI
import SwiftUI
struct TextFieldProvider: PreviewProvider {
    static var previews: some View {
        
        Group {
            ContainterView().edgesIgnoringSafeArea(.all)
            .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
            .previewDisplayName("iPhone XS Max")
           ContainterView().edgesIgnoringSafeArea(.all)
              .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
              .previewDisplayName("iPhone 8")
        }
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let tabBar = ProfileViewController(user: MUser(username: "dfd", avatarStringURL: "fdf", email: "frgr", description: "frf", sex: "frfr", identifier: "fefe"),
        currentUser: MUser(username: "ddedfd", avatarStringURL: "fddef", email: "frgdedr", description: "frdaf", sex: "farfr", identifier: "fefeg"))
        func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldProvider.ContainterView>) -> ProfileViewController {
            return tabBar
        }
        
        func updateUIViewController(_ uiViewController: TextFieldProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<TextFieldProvider.ContainterView>) {
            
        }
    }
}
