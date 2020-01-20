//
//  PeopleViewController.swift
//  Chats
//
//  Created by Алексей Пархоменко on 10.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case main
        func description(usersCount: Int) -> String {
            switch self {
            case .main:
                return "\(usersCount) people nearby"
            }
        }
    }
    
    let usersController = UsersController()
    var dataSource: UICollectionViewDiffableDataSource<Section, UsersController.MUser>!
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSearchBar()
        createDataSource()
        reloadData(with: nil)
    }
    
    // MARK: Setup UI Elements
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseId)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.delegate = self
    }
    
    // MARK: - Manage the data in UICV
    
    func configure<T: SelfConfiguringCell, U: Decodable>(cellType: T.Type, with value: U, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else { fatalError("Unable to dequeue \(cellType)") }
        cell.configure(with: value)
        return cell
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, UsersController.MUser>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            
            guard let section = Section(rawValue: indexPath.section)
            else { fatalError("Unknown section kind") }
            
            switch section {
            case .main:
                return self.configure(cellType: UserCell.self, with: user, for: indexPath)
            }
        
        })
        
        dataSource.supplementaryViewProvider = { [weak self]
            (collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let section = Section(rawValue: indexPath.section)
                else { fatalError("Unknown section kind") }
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeader.reuseId,
                for: indexPath) as? SectionHeader
                else {
                    fatalError("Cannot create new header")
            }
            
            let items = self?.dataSource.snapshot().itemIdentifiers(inSection: .main)
            let text = section.description(usersCount: items?.count ?? 0)
            sectionHeader.configure(
                text: text,
                font: .systemFont(ofSize: 36, weight: .light),
                textColor: .label)
            
            return sectionHeader
        }
    }
    
    // TODO: limit don't work
    private func reloadData(with searchText: String?) {
        let users = usersController.filteredUsers(with: searchText)
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, UsersController.MUser>()
        snapshot.appendSections([.main])
        snapshot.appendItems(users, toSection: .main)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Setup Layout

extension PeopleViewController {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(15)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 15, bottom: 0, trailing: 15)
        
        let layoutSectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [layoutSectionHeader]

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                             heightDimension: .estimated(1))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)

        return layoutSectionHeader
    }
}

// MARK: - UICollectionViewDelegate
extension PeopleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        let profileVC = ProfileViewController()
        present(profileVC, animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate
extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
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
