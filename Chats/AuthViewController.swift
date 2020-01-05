//
//  AuthViewController.swift
//  Chats
//
//  Created by Алексей Пархоменко on 05.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class AuthViewController: UIViewController {
    
    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo"), contentMode: .scaleAspectFit)
    
    let googleLabel = UILabel(text: "Get started with", font: UIFont.init(name: "avenir", size: 20))
    let emailLabel = UILabel(text: "Or sign up with", font: UIFont.init(name: "avenir", size: 20))
    let alreadyOnboardLabel = UILabel(text: "Already onboard?", font: UIFont.init(name: "avenir", size: 20))
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, font: UIFont.init(name: "avenir", size: 20), isShadow: true, cornerRadius: 4)
    let emailButton = UIButton(title: "Email", titleColor: .white, backgroundColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), font: UIFont.init(name: "avenir", size: 20), cornerRadius: 4)
    let loginButton = UIButton(title: "Login", titleColor: #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1), backgroundColor: .white, font: UIFont.init(name: "avenir", size: 20), isShadow: true, cornerRadius: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
    }
    
    private func setupConstraints() {
        googleButton.customizeGoogleButton()
        let googleView = UIView(label: googleLabel, button: googleButton)
        let emailView = UIView(label: emailLabel, button: emailButton)
        let loginView = UIView(label: alreadyOnboardLabel, button: loginButton)

        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView], axis: .vertical, spacing: 40)
        
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: logoImageView.topAnchor, constant: 160).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
    }
}

struct AuthVCProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let authVC = AuthViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<AuthVCProvider.ContainterView>) -> AuthViewController {
            return authVC
        }
        
        func updateUIViewController(_ uiViewController: AuthVCProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<AuthVCProvider.ContainterView>) {
            
        }
    }
}
