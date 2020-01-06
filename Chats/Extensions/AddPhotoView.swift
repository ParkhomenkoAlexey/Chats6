//
//  AddPhotoView.swift
//  Chats
//
//  Created by Алексей Пархоменко on 06.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

class AddPhotoView: UIView {
    
    let circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "avatar")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let myImage = #imageLiteral(resourceName: "plus")
        button.setImage(myImage, for: .normal)
        button.tintColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(circleImageView)
        addSubview(plusButton)
        makeConstraints()
    }
    
    private func makeConstraints() {
        // circleImageView constraints
        circleImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        circleImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        circleImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        circleImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        // plusButton constraints
        plusButton.leadingAnchor.constraint(equalTo: circleImageView.trailingAnchor, constant: 16).isActive = true
        plusButton.centerYAnchor.constraint(equalTo: circleImageView.centerYAnchor).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.bottomAnchor.constraint(equalTo: circleImageView.bottomAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: plusButton.trailingAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleImageView.layer.masksToBounds = true
        circleImageView.layer.cornerRadius = circleImageView.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
