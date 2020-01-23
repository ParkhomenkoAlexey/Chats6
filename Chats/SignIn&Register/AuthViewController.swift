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
import GoogleSignIn
import FirebaseAuth
import Firebase

class AuthViewController: UIViewController {
    
    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo"), contentMode: .scaleAspectFit)
    
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true, cornerRadius: 4)
    let emailButton = UIButton(title: "Email", titleColor: .white, backgroundColor: .buttonDark(), cornerRadius: 4)
    let loginButton = UIButton(title: "Login", titleColor: .buttonRed(), backgroundColor: .white, isShadow: true, cornerRadius: 4)
    
    var loginVC = LoginViewController()
    var signUpVC = SignUpViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
        
        
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        emailButton.addTarget(self, action: #selector(toSignUpVC), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(toLoginVC), for: .touchUpInside)
        
        GIDSignIn.sharedInstance()?.delegate = self
        signUpVC.delegate = self
        loginVC.delegate = self
    }

    
}

// MARK: - Actions
extension AuthViewController {
    @objc func googleButtonTapped() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
}

// MARK: - AuthNavigation Protocol
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

// MARK: - GIDSignInDelegate
extension AuthViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        AuthService.shared.googleLogin(user: user, error: error) { (result) in
            switch result {
            case .success(let user):
                FirestoreService.shared.getUserData(user: user) { (result) in
                    switch result {
                    case .success(let muser):
                        UIApplication.getTopViewController()?.showAlert(with: "Успешно", and: "Вы авторизированны!", completion: {
                            let mainTabBar = MainTabBarController(currentUser: muser)
                            mainTabBar.modalPresentationStyle = .fullScreen
                            UIApplication.getTopViewController()?.present(mainTabBar, animated: true, completion: nil)
                        })
                    case .failure(_):
                        UIApplication.getTopViewController()?.showAlert(with: "Успешно", and: "Вы зарегистрированы!", completion: {
                            UIApplication.getTopViewController()?.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                        })
                    }
                }
            case .failure(let error):
                self.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
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
