//
//  LoginViewController.swift
//  Chats
//
//  Created by Алексей Пархоменко on 06.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class LoginViewController: UIViewController {
    
    let welcomeLabel = UILabel(text: "Welcome back!", font: UIFont.init(name: "avenir", size: 26))
    
    let loginWithLabel = UILabel(text: "Login with", font: UIFont.init(name: "avenir", size: 20))
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, font: UIFont.init(name: "avenir", size: 20), isShadow: true, cornerRadius: 4)
    
    let orLabel = UILabel(text: "or", font: UIFont.init(name: "avenir", size: 20))
    
    let emailLabel = UILabel(text: "Email", font: UIFont.init(name: "avenir", size: 20))
    let emailTextField = OneLineTextField(font: UIFont.init(name: "avenir", size: 20), borderStyle: .none)
    let passwordLabel = UILabel(text: "Password", font: UIFont.init(name: "avenir", size: 20))
    let passwordTextField = OneLineTextField(font: UIFont.init(name: "avenir", size: 20), borderStyle: .none)
    
    let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), font: UIFont.init(name: "avenir", size: 20), isShadow: false, cornerRadius: 4)
    
    let needAnAccountLabel = UILabel(text: "Need an account?", font: UIFont.init(name: "avenir", size: 20))
    let signUpButton = UIButton(title: "  Sign Up", titleColor: #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1), font: UIFont.init(name: "avenir", size: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
    }
    
    private func setupConstraints() {
        googleButton.customizeGoogleButton()
        let loginWithView = UIView(label: loginWithLabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubviews:
            [emailLabel, emailTextField],
                                         axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews:
            [passwordLabel, passwordTextField],
                                            axis: .vertical, spacing: 0)
        
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews:
            [loginWithView, orLabel, emailStackView, passwordStackView, loginButton],
                                    axis: .vertical, spacing: 40)
        
        signUpButton.contentHorizontalAlignment = .leading
        let bottomStackView = UIStackView(arrangedSubviews: [needAnAccountLabel, signUpButton], axis: .horizontal, spacing: -1) // чит, с нулем не работает
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: welcomeLabel.topAnchor, constant: 120).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
        bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
    }
}

struct LoginVCProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let loginVC = LoginViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<LoginVCProvider.ContainterView>) -> LoginViewController {
            return loginVC
        }
        
        func updateUIViewController(_ uiViewController: LoginVCProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<LoginVCProvider.ContainterView>) {
            
        }
    }
}
