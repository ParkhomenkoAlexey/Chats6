//
//  ChatRequestViewController.swift
//  Chats
//
//  Created by Алексей Пархоменко on 19.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

class ChatRequestViewController: UIViewController {
    
    let containerView = UIView()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "human1"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Peter Ben", font: .systemFont(ofSize: 20, weight: .light))
    let descLabel = UILabel(text: "You have the opportunity to start a new chat", font: .systemFont(ofSize: 16, weight: .light))
    let acceptButton = UIButton(title: "ACCEPT", titleColor: .white, backgroundColor: .black, font: .laoSangamMN20())
    let denyButton = UIButton(title: "Deny", titleColor: #colorLiteral(red: 0.8352941176, green: 0.2, blue: 0.2, alpha: 1), backgroundColor: .mainWhite(), font: .laoSangamMN20(), cornerRadius: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        customizeElements()
        setupConstraints()
    }
    
    func customizeElements() {
        denyButton.layer.borderWidth = 1.2
        denyButton.layer.borderColor = #colorLiteral(red: 0.8352941176, green: 0.2, blue: 0.2, alpha: 1)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.acceptButton.applyGradients(cornerRadius: 10)
    }
}



// MARK: - Setup Constraints
extension ChatRequestViewController {
    func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .mainWhite()
        containerView.layer.cornerRadius = 30
        
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descLabel)
        
        let buttonsStackView = UIStackView(arrangedSubviews: [acceptButton, denyButton], axis: .horizontal, spacing: 7)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.distribution = .fillEqually
        containerView.addSubview(buttonsStackView)
        
        // imageView constraints
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30).isActive = true

        // containerView constraints
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 206).isActive = true
        
        // nameLabel constraints
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24).isActive = true
        
        // descLabel constraints
        descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24).isActive = true
        
        // buttonsStackView constraints
        buttonsStackView.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 24).isActive = true
        buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24).isActive = true
        buttonsStackView.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
}

// MARK: - SwiftUI
import SwiftUI
struct ChatRequestProvider: PreviewProvider {
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
        
        let tabBar = ChatRequestViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<ChatRequestProvider.ContainterView>) -> ChatRequestViewController {
            return tabBar
        }
        
        func updateUIViewController(_ uiViewController: ChatRequestProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<ChatRequestProvider.ContainterView>) {
            
        }
    }
}
