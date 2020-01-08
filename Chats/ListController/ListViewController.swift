//
//  ListViewController.swift
//  Chats
//
//  Created by Алексей Пархоменко on 07.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController {
    
    let sections = Bundle.main.decode([MSection].self, from: "model.json")
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<MSection, MChat>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.reuseId)
        
        createDataSource()
        reloadData()
    }
    
    func configure<T: SelfConfiguringCell>(cellType: T.Type, with chat: MChat, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else { fatalError("Unable to dequeue \(cellType)") }
        cell.configure(with: chat)
        return cell
    }
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MSection, MChat>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chat) -> UICollectionViewCell? in
            switch self.sections[indexPath.section].type {
            default:
                return self.configure(cellType: ListCell.self, with: chat, for: indexPath)
            }
        })
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<MSection, MChat>()
        snapshot.appendSections(sections)
        
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource?.apply(snapshot)
    }
}

// MARK: - SwiftUI
import SwiftUI
struct ListProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let tabBar = MainTabBarController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<ListProvider.ContainterView>) -> MainTabBarController {
            return tabBar
        }
        
        func updateUIViewController(_ uiViewController: ListProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<ListProvider.ContainterView>) {
            
        }
    }
}
