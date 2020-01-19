//
//  ProfileViewController.swift
//  Chats
//
//  Created by Алексей Пархоменко on 20.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    let containerView = UIView()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "human1"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Peter Ben", font: .systemFont(ofSize: 20, weight: .light))
    let aboutMeLabel = UILabel(text: "You have the opportunity to chat with the most beautifull guy in the Moscow", font: .systemFont(ofSize: 16, weight: .light))
    let myTextField = InsetableTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        customizeElements()
        setupConstraints()
    }
    
    func customizeElements() {
        aboutMeLabel.numberOfLines = 0
    }
}



// MARK: - Setup Constraints
extension ProfileViewController {
    func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .mainWhite()
        containerView.layer.cornerRadius = 30
        
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutMeLabel)
        containerView.addSubview(myTextField)
    
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
        
        // aboutMeLabel constraints
        aboutMeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        aboutMeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24).isActive = true
        aboutMeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24).isActive = true
        
        // messageTextField constraints
        myTextField.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 8).isActive = true
        myTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24).isActive = true
        myTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24).isActive = true
        myTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
}

// MARK: - SwiftUI
import SwiftUI
struct ProfileProvider: PreviewProvider {
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
        
        let tabBar = ProfileViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProfileProvider.ContainterView>) -> ProfileViewController {
            return tabBar
        }
        
        func updateUIViewController(_ uiViewController: ProfileProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProfileProvider.ContainterView>) {
            
        }
    }
}
