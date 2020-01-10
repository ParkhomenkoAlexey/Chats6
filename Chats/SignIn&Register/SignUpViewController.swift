//
//  SignUpViewController.swift
//  Chats
//
//  Created by Алексей Пархоменко on 05.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class SignUpViewController: UIViewController {
    
    let welcomeLabel = UILabel(text: "Good to see you!", font: UIFont.init(name: "avenir", size: 26))
    
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let confirmPasswordLabel = UILabel(text: "Confirm password")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    let confirmPasswordTextField = OneLineTextField(font: .avenir20())
    
    let signUpButton = UIButton(title: "Sign Up", titleColor: .white, backgroundColor: .buttonDark(), cornerRadius: 4)
    let loginButton = UIButton(title: "  Login", titleColor: .buttonRed())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
    }
}

// MARK: - Setup Constraints
extension SignUpViewController {
    private func setupConstraints() {
        let emailStackView = UIStackView(arrangedSubviews:
            [emailLabel, emailTextField],
                                         axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews:
            [passwordLabel, passwordTextField],
                                            axis: .vertical, spacing: 0)
        let confirmPasswordStackView = UIStackView(arrangedSubviews:
            [confirmPasswordLabel, confirmPasswordTextField],
                                                   axis: .vertical, spacing: 0)
        
        signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews:
            [emailStackView, passwordStackView, confirmPasswordStackView, signUpButton],
                                    axis: .vertical, spacing: 40)
        
        
        loginButton.contentHorizontalAlignment = .leading
        let bottomStackView = UIStackView(arrangedSubviews: [alreadyOnboardLabel, loginButton], axis: .horizontal, spacing: -1) // чит, с нулем не работает
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: welcomeLabel.topAnchor, constant: 160).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
        bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
    }
}

// MARK: - SwiftUI
struct SignUpVCProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let signUpVC = SignUpViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<SignUpVCProvider.ContainterView>) -> SignUpViewController {
            return signUpVC
        }
        
        func updateUIViewController(_ uiViewController: SignUpVCProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<SignUpVCProvider.ContainterView>) {
            
        }
    }
}
