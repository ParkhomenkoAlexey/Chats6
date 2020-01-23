//
//  HumanCell.swift
//  Chats
//
//  Created by Алексей Пархоменко on 10.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class UserCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId: String = "UserCell"
    
    let userImageView = UIImageView()
    let userName = UILabel(text: "test", font: .laoSangamMN20())
    
    override func prepareForReuse() {
        userImageView.image = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 1, alpha: 1)
        setupConstraints()
        
        self.layer.cornerRadius = 4

        self.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    // TODO - fix shadows with image
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = 4
        userImageView.clipsToBounds = true
    }
    
    
    func configure<U>(with value: U) where U : Decodable {
        guard let user: MUser = value as? MUser else { return }
        userName.text = user.username
        guard let url = URL(string: user.avatarStringURL) else { return }
        userImageView.sd_setImage(with: url, completed: nil)
    }
    
    func setupConstraints() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview((userImageView), at: 0)
        insertSubview((userName), at: 0)
        
        // userImageView constraints
        userImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        userImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        userImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor).isActive = true
        
        // userName constraints
        userName.topAnchor.constraint(equalTo: userImageView.bottomAnchor).isActive = true
        userName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        userName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        userName.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SwiftUI
import SwiftUI
struct UserCellProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let tabBar = MainTabBarController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<UserCellProvider.ContainterView>) -> MainTabBarController {
            return tabBar
        }
        
        func updateUIViewController(_ uiViewController: UserCellProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<UserCellProvider.ContainterView>) {
            
        }
    }
}
