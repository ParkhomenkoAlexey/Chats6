//
//  MessageCell.swift
//  Chats
//
//  Created by Алексей Пархоменко on 20.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

class MessageCell: UITableViewCell {
    
    static let reuseId = "MessageCell"
    
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "We want to provide a longer string that is actually going to wrap onto the next line and maybe even a third line."
        label.numberOfLines = 0
        
        return label
    }()
    let bubbleBackgroundView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor(white: 0.85, alpha: 1)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        setupConstraints()
    }
    
    
    
    func set(message: MMessage) {
        messageLabel.text = message.content
        
//        if message.isIncoming {
//            bubbleBackgroundView.backgroundColor = UIColor(white: 0.85, alpha: 1)
//            messageLabel.textColor = .black
//            leadingConstraint.isActive = true
//            trailingConstraint.isActive = false
//        } else {
//            bubbleBackgroundView.backgroundColor = .black
//            messageLabel.textColor = .white
//            leadingConstraint.isActive = false
//            trailingConstraint.isActive = true
//        }
    }
    
    func setupConstraints() {
        
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)

        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
        messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
//        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
//        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)

        bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16).isActive = true
        bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16).isActive = true
        bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16).isActive = true
        bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import SwiftUI
struct MessageCellProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
//        let user = UsersController.MUser(username: "Abla", avatarStringURL: "human1", sex: "male")
//        let chat = MChat(friendName: "Bobik", friendImage: "human2", lastMessage: "Sorry!")
        let chatVC: ChatViewController = ChatViewController(
            user: UsersController.MUser(username: "Abla", avatarStringURL: "human1", sex: "male"),
            chat: MChat(friendName: "Bobik", friendImage: "human2", lastMessage: "Sorry!"))
        func makeUIViewController(context: UIViewControllerRepresentableContext<MessageCellProvider.ContainterView>) -> ChatViewController {
            return chatVC
        }
        
        func updateUIViewController(_ uiViewController: MessageCellProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<MessageCellProvider.ContainterView>) {
            
        }
    }
}

