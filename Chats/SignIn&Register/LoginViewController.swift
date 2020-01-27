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
import GoogleSignIn

class LoginViewController: UIViewController {
    
    let welcomeLabel = UILabel(text: "Welcome back!", font: .avenir26())
    
    let loginWithLabel = UILabel(text: "Login with")
    let orLabel = UILabel(text: "or")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let needAnAccountLabel = UILabel(text: "Need an account?")
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true, cornerRadius: 4)
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    
    let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .buttonDark(), cornerRadius: 4)
    let signUpButton = UIButton(title: "  Sign Up", titleColor: .buttonRed())
    
    weak var delegate: AuthNavigation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        
        googleButton.addTarget(self, action: #selector(googleButtonPressed), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
    }
}

// MARK: - Actions
extension LoginViewController {
    
    @objc func googleButtonPressed() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc func loginButtonPressed() {
        AuthService.shared.login(email: emailTextField.text, password: passwordTextField.text) { (result) in
            switch result {
            case .success(let user):
                self.showAlert(with: "Успешно", and: "Вы авторизированны!", completion: {
                    FirestoreService.shared.getUserData(user: user) { (result) in
                        switch result {
                        case .success(let muser):
                            let mainTabBar = MainTabBarController(currentUser: muser)
                            mainTabBar.modalPresentationStyle = .fullScreen
                            self.present(mainTabBar, animated: true, completion: nil)
                        case .failure(_):
                            self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                        }
                    }
                })
            case .failure(let error):
                self.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
    }
    
    @objc func signUpButtonPressed() {
        self.dismiss(animated: true) { [delegate] in
            delegate?.toSignUpVC()
        }
    }
}

// MARK: - Setup Constraints
extension LoginViewController {
    private func setupConstraints() {
        googleButton.customizeGoogleButton()
        let loginWithView = ButtonFormView(label: loginWithLabel, button: googleButton)
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
        let bottomStackView = UIStackView(arrangedSubviews: [needAnAccountLabel, signUpButton], axis: .horizontal, spacing: 0) // чит, с нулем не работает
        bottomStackView.alignment = .firstBaseline
        
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

// MARK: - SwiftUI
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
