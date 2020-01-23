//
//  SetupProfileViewController.swift
//  Chats
//
//  Created by Алексей Пархоменко on 06.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

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
    
    private let currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        if let username = currentUser.displayName {
            fullNameTextField.text = username
        }
        if let photoURL = currentUser.photoURL {
            fullImageView.circleImageView.setImage(imageURL: photoURL.absoluteString)
        }
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        
        goToChatsButton.addTarget(self, action: #selector(goToChatsButtonTapped), for: .touchUpInside)
        fullImageView.plusButton.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)
    }
    
    
}

// MARK: - Actions
extension SetupProfileViewController {
    @objc func goToChatsButtonTapped() {
        FirestoreService.shared.saveProfileWith(
            id: currentUser.uid, email: currentUser.email, username: fullNameTextField.text,
            avatarImage: fullImageView.circleImageView.image,
            description: aboutMeTextField.text,
            sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex)) { (result) in
                switch result {
                case .success(let muser):
                    self.showAlert(with: "Успешно", and: "Данные сохранены!", completion: {
                        let mainTabBar = MainTabBarController(currentUser: muser)
                        mainTabBar.modalPresentationStyle = .fullScreen
                        self.present(mainTabBar, animated: true, completion: nil)
                    })
                case .failure(let error):
                    self.showAlert(with: "Ошибка", and: error.localizedDescription)
                }
        }
    }
    
    @objc func addPhotoTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: - Setup Constraints
extension SetupProfileViewController {
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
        
        view.addSubview(welcomeLabel)
        view.addSubview(fullImageView)
        view.addSubview(stackView)
        
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        fullImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40).isActive = true
        fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 40).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
    }
}

// MARK: - UIImagePickerControllerDelegate
extension SetupProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        fullImageView.circleImageView.image = image
    }
}


// MARK: - SwiftUI
import SwiftUI
struct SetupProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let SetupProfileVC = SetupProfileViewController(currentUser: Auth.auth().currentUser!)
        func makeUIViewController(context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainterView>) -> SetupProfileViewController {
            return SetupProfileVC
        }
        
        func updateUIViewController(_ uiViewController: SetupProfileVCProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainterView>) {
            
        }
    }
}
