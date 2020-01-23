//
//  MainTabBarController.swift
//  Chats
//
//  Created by Алексей Пархоменко on 07.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI


class MainTabBarController: UITabBarController {
    
    private let currentUser: UsersController.MUser
    
    init(currentUser: UsersController.MUser = UsersController.MUser(username: "dfd", avatarStringURL: "fdf", email: "frgr", description: "frf", sex: "frfr", identifier: "fefe")) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("#function: \(#function) currentUser.username: \(currentUser.username)")
        view.backgroundColor = .white
        
        let listViewController = ListViewController()
        let peopleViewController = PeopleViewController()
        
        tabBar.tintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        let convImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig)!
        let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfig)!
        
        viewControllers = [
            generateNavigationController(rootViewController: listViewController,
            title: "Conversations",
            image: convImage),
            generateNavigationController(rootViewController: peopleViewController,
            title: "People",
            image: peopleImage)
            
            
            
            
            
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
    
}

// MARK: - SwiftUI
struct MainTabBarProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let tabBar = MainTabBarController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<MainTabBarProvider.ContainterView>) -> MainTabBarController {
            return tabBar
        }
        
        func updateUIViewController(_ uiViewController: MainTabBarProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<MainTabBarProvider.ContainterView>) {
            
        }
    }
}

