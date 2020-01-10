//
//  SectionHeader.swift
//  Chats
//
//  Created by Алексей Пархоменко on 09.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    static let reuseId = "SectionHeader"
    
    let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        customizeElements()
        setupConstraints()
    }
    
    func customizeElements() {

        title.textColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
        title.font = .laoSangamMN20()
        title.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        addSubview(title)
        title.fillSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SwiftUI
import SwiftUI
struct SectionHeaderProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let tabBar = MainTabBarController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<SectionHeaderProvider.ContainterView>) -> MainTabBarController {
            return tabBar
        }
        
        func updateUIViewController(_ uiViewController: SectionHeaderProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<SectionHeaderProvider.ContainterView>) {
            
        }
    }
}
