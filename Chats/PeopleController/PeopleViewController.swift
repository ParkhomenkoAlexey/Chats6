//
//  PeopleViewController.swift
//  Chats
//
//  Created by Алексей Пархоменко on 10.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
}

extension PeopleViewController {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.55))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(15)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension PeopleViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseId)
        view.addSubview(collectionView)
    }
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in

            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: UserCell.reuseId,
                for: indexPath) as? UserCell else { fatalError("Cannot create new cell") }

            // Populate the cell with our item description.
//            cell.label.text = "\(identifier)"
//            cell.contentView.backgroundColor = .cornflowerBlue
//            cell.layer.borderColor = UIColor.black.cgColor
//            cell.layer.borderWidth = 1
//            cell.label.textAlignment = .center
//            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)

            // Return the cell.
            return cell
        }

        // initial data
            
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<94))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - SwiftUI
import SwiftUI
struct PeopleProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let tabBar = MainTabBarController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<PeopleProvider.ContainterView>) -> MainTabBarController {
            return tabBar
        }
        
        func updateUIViewController(_ uiViewController: PeopleProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<PeopleProvider.ContainterView>) {
            
        }
    }
}
