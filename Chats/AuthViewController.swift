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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
    
}

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
