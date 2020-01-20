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
    
    let sections = Bundle.main.decode([MSection].self, from: "chats.json")
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<MSection, MChat>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupCollectionView()
    }
    
    // MARK: Setup UI Elements
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        navigationController?.navigationBar.shadowImage = UIImage()
        let seacrhController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = seacrhController
        navigationItem.hidesSearchBarWhenScrolling = false
        seacrhController.hidesNavigationBarDuringPresentation = true
        seacrhController.obscuresBackgroundDuringPresentation = false
        seacrhController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
        
        collectionView.delegate = self
        
        createDataSource()
        reloadData()
    }
    
    // MARK: - Manage the data in UICV
    
    func configure<T: SelfConfiguringCell, U: Decodable>(cellType: T.Type, with value: U, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else { fatalError("Unable to dequeue \(cellType)") }
        cell.configure(with: value)
        return cell
    }
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MSection, MChat>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chat) -> UICollectionViewCell? in
            switch self.sections[indexPath.section].type {
            case "waitingChats":
                return self.configure(cellType: WaitingChatCell.self, with: chat, for: indexPath)
            default:
                return self.configure(cellType: ActiveChatCell.self, with: chat, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = { [weak self]
            collectionView,
            kind,
            indexPath in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Cannot create new supplementary") }
            
            guard let firstChat = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstChat) else { return nil }
            if section.title.isEmpty { return nil }
            
            sectionHeader.configure(
                text: section.title,
                font: .laoSangamMN20(),
                textColor: #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1))
            return sectionHeader
            
        }
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<MSection, MChat>()
        snapshot.appendSections(sections)
        
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource?.apply(snapshot)
    }
    
    // MARK: - Setup Layout
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self.sections[sectionIndex]
            
            switch section.type {
            case "waitingChats":
                return self.createWaitingChatSection(using: section)
            default:
                return self.createActiveChatSection(using: section)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    // create single section
    // TODO - сделать пересчет layout для waiting
    func createWaitingChatSection(using section: MSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(104),
                                                     heightDimension: .estimated(88))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 12, bottom: 0, trailing: 12)
        
        let layoutSectionHeader = createSectionHeader()
        layoutSectionHeader.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 5, bottom: 0, trailing: 0)
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    func createActiveChatSection(using section: MSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(86))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)
        
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .estimated(1))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
        
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
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
extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let chat = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        let section = sections[indexPath.section]
        switch section.type {
        case "waitingChats":
            print(chat.friendName)
        default:
            print(chat.lastMessage)
            let currentUser = UsersController.MUser(username: "Me", avatarStringURL: "human3", sex: "male")
            let vc = ChatViewController(user: currentUser, chat: chat)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate
extension ListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
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
