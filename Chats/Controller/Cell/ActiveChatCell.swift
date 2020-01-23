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

class ActiveChatCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId: String = "ListCell"
    
    let friendImageView = UIImageView()
    let friendName = UILabel(text: "User name", font: .laoSangamMN20())
    let lastMessage = UILabel(text: "Hey girl, what's up there? Let's go out and have a drink tonight?", font: .laoSangamMN18())
    let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, inColor: #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1), toColor: #colorLiteral(red: 0.4784313725, green: 0.6980392157, blue: 0.9215686275, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 1, alpha: 1)
        setupConstraints()
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let chat: MChat = value as? MChat else { return }
        friendName.text = chat.friendUsername
        lastMessage.text = chat.lastMessageContent
        guard let url = URL(string: chat.friendAvatarStringURL) else { return }
        friendImageView.sd_setImage(with: url, completed: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup Constraints
extension ActiveChatCell {
    func setupConstraints() {
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        friendImageView.backgroundColor = .black
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(friendImageView)
        addSubview(gradientView)
        addSubview(friendName)
        addSubview(lastMessage)
        
        // oponentImageView constraints
        friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        friendImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        friendImageView.widthAnchor.constraint(equalToConstant: 78).isActive = true
        friendImageView.heightAnchor.constraint(equalToConstant: 78).isActive = true
        
        // gradientView constraints
        gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        gradientView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        gradientView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive  = true
        
        // oponentLabel constraints
        friendName.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        friendName.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16).isActive = true
        friendName.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16).isActive = true
        
        // lastMessageLabel constraints
        lastMessage.topAnchor.constraint(equalTo: friendName.bottomAnchor).isActive = true
        lastMessage.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16).isActive = true
        lastMessage.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: -16).isActive = true
    }
}

// MARK: - SwiftUI
struct ListCellCellProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let tabBar = MainTabBarController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<ListCellCellProvider.ContainterView>) -> MainTabBarController {
            return tabBar
        }
        
        func updateUIViewController(_ uiViewController: ListCellCellProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<ListCellCellProvider.ContainterView>) {
            
        }
    }
}
