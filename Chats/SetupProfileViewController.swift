//
//  SetupProfileViewController.swift
//  Chats
//
//  Created by Алексей Пархоменко on 06.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class SetupProfileViewController: UIViewController {
    
    let welcomeLabel = UILabel(text: "Set up profile", font: .avenir26())
    
    let fullImageView = AddPhotoView()
    
    let fullNameLabel = UILabel(text: "Full name")
    let aboutMeLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")
    let needAnAccountLabel = UILabel(text: "Need an account?")
    
    let fullNameTextField = OneLineTextField(font: .avenir20())
    let aboutMeTextField = OneLineTextField(font: .avenir20())
    let sexSegmentedControl = UISegmentedControl(first: "Male", second: "Female")
    
    let goToChatsButton = UIButton(title: "Go to chats!", titleColor: .white, backgroundColor: .buttonDark(), cornerRadius: 4)
    
    let signUpButton = UIButton(title: "  Sign Up", titleColor: .buttonRed())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        let fullNameStackView = UIStackView(arrangedSubviews:
            [fullNameLabel, fullNameTextField],
                                         axis: .vertical, spacing: 0)
        let aboutMeStackView = UIStackView(arrangedSubviews:
            [aboutMeLabel, aboutMeTextField],
                                            axis: .vertical, spacing: 0)
        
        let sexStackView = UIStackView(arrangedSubviews:
        [sexLabel, sexSegmentedControl],
                                        axis: .vertical, spacing: 12)
        
        goToChatsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews:
        [fullImageView, fullNameStackView, aboutMeStackView, sexStackView, goToChatsButton],
                                axis: .vertical, spacing: 40)
        
        signUpButton.contentHorizontalAlignment = .leading
        let bottomStackView = UIStackView(arrangedSubviews: [needAnAccountLabel, signUpButton], axis: .horizontal, spacing: -1) // чит, с нулем не работает
        
        view.addSubview(welcomeLabel)
        view.addSubview(fullImageView)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        fullImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40).isActive = true
        fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 40).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
        bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
    }
}


struct SetupProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let SetupProfileVC = SetupProfileViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainterView>) -> SetupProfileViewController {
            return SetupProfileVC
        }
        
        func updateUIViewController(_ uiViewController: SetupProfileVCProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainterView>) {
            
        }
    }
}
