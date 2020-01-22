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
    
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true, cornerRadius: 4)
    let emailButton = UIButton(title: "Email", titleColor: .white, backgroundColor: .buttonDark(), cornerRadius: 4)
    let loginButton = UIButton(title: "Login", titleColor: .buttonRed(), backgroundColor: .white, isShadow: true, cornerRadius: 4)
    
    var loginVC: LoginViewController!
    var signUpVC: SignUpViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
        
        emailButton.addTarget(self, action: #selector(toSignUpVC), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(toLoginVC), for: .touchUpInside)
        
        loginVC = LoginViewController()
        signUpVC = SignUpViewController()
        signUpVC.delegate = self
        loginVC.delegate = self
    }

}

extension AuthViewController: AuthNavigation {
    @objc func toLoginVC() {
        present(loginVC, animated: true, completion: nil)
    }
    
    @objc func toSignUpVC() {
        present(signUpVC, animated: true, completion: nil)
    }
}

// MARK: - Setup Constraints
extension AuthViewController {
    private func setupConstraints() {
        googleButton.customizeGoogleButton()
        let googleView = ButtonFormView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormView(label: alreadyOnboardLabel, button: loginButton)

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

// MARK: - SwiftUI
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
