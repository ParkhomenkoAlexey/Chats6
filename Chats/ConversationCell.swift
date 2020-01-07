//
//  ConversationCell.swift
//  Chats
//
//  Created by Алексей Пархоменко on 07.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class ConversationCell: UICollectionViewCell {
    
    static let reuseId = "ConversationCell"
    
    let oponentImageView = UIImageView()
    let oponentLabel = UILabel(text: "User name", font: .laoSangamMN20())
    let lastMessageLabel = UILabel(text: "Hey girl, what's up there? Let's go out and have a drink tonight?", font: .laoSangamMN18())
    let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, inColor: #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1), toColor: #colorLiteral(red: 0.4784313725, green: 0.6980392157, blue: 0.9215686275, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 1, alpha: 1)
        setupConstraints()
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    func set(chat: Chat) {
        oponentLabel.text = chat.oponentName
        lastMessageLabel.text = chat.text
        oponentImageView.setImage(imageURL: chat.oponentImageName)
    }
    
    func setupConstraints() {
        oponentImageView.translatesAutoresizingMaskIntoConstraints = false
        oponentImageView.backgroundColor = .black
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(oponentImageView)
        addSubview(gradientView)
        addSubview(oponentLabel)
        addSubview(lastMessageLabel)
        
        // oponentImageView constraints
        oponentImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        oponentImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        oponentImageView.widthAnchor.constraint(equalToConstant: 78).isActive = true
        oponentImageView.heightAnchor.constraint(equalToConstant: 78).isActive = true
        
        // gradientView constraints
        gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        gradientView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        gradientView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive  = true
        
        // oponentLabel constraints
        oponentLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        oponentLabel.leadingAnchor.constraint(equalTo: oponentImageView.trailingAnchor, constant: 16).isActive = true
        oponentLabel.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16).isActive = true
        
        // lastMessageLabel constraints
        lastMessageLabel.topAnchor.constraint(equalTo: oponentLabel.bottomAnchor).isActive = true
        lastMessageLabel.leadingAnchor.constraint(equalTo: oponentImageView.trailingAnchor, constant: 16).isActive = true
        lastMessageLabel.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: -16).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct ConversationCellProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let tabBar = MainTabBarController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<ConversationCellProvider.ContainterView>) -> MainTabBarController {
            return tabBar
        }
        
        func updateUIViewController(_ uiViewController: ConversationCellProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<ConversationCellProvider.ContainterView>) {
            
        }
    }
}
