//
//  HumanCell.swift
//  Chats
//
//  Created by Алексей Пархоменко on 10.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

class UserCell: UICollectionViewCell {

    static var reuseId: String = "UserCell"
    
    let friendImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 1, alpha: 1)
        setupConstraints()
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    func setupConstraints() {
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        friendImageView.backgroundColor = .blue
        addSubview(friendImageView)
        friendImageView.fillSuperview()
    }
    
    func configure(with user: MUser) {
//        friendImageView.image = UIImage(named: chat.friendImage)
        print("123")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
