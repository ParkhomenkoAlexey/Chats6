//
//  ListViewController.swift
//  Chats
//
//  Created by Алексей Пархоменко on 07.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class ListViewController: UIViewController {
    
    let sections = [MSection]()
    private var whaitingChats: [MChat] = [
        MChat(friendUsername: "frfr", friendAvatarStringURL: "frefe", friendIdentifier: "fre", lastMessageContent: "fre"),
        MChat(friendUsername: "frfssdr", friendAvatarStringURL: "fretfe", friendIdentifier: "fregr", lastMessageContent: "ffrre"),
        MChat(friendUsername: "frftfr", friendAvatarStringURL: "fwwrefe", friendIdentifier: "frwe", lastMessageContent: "fggre")
    ]
    
    private var activeChats: [MChat] = [
        MChat(friendUsername: "gtr", friendAvatarStringURL: "frefe", friendIdentifier: "fre", lastMessageContent: "fre"),
        MChat(friendUsername: "wer", friendAvatarStringURL: "fretfe", friendIdentifier: "fregr", lastMessageContent: "ffrre"),
        MChat(friendUsername: "wer", friendAvatarStringURL: "fwwrefe", friendIdentifier: "frwe", lastMessageContent: "fggre")
    ]
    
    enum Section: Int, CaseIterable {
        case waitingChats, activeChats
        
        func description() -> String {
            switch self {
            case .waitingChats:
                return "Waiting chats"
            case .activeChats:
                return "Active chats"
            }
        }
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MChat>?

    private let currentUser: MUser
    
    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupCollectionView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(signOut))
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
    
    func configure<T: SelfConfiguringCell, U: Hashable>(cellType: T.Type, with value: U, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else { fatalError("Unable to dequeue \(cellType)") }
        cell.configure(with: value)
        return cell
    }
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MChat>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chat) -> UICollectionViewCell? in
            
            guard let section = Section(rawValue: indexPath.section)
            else { fatalError("Unknown section kind") }

            switch section {
            case .waitingChats:
                return self.configure(cellType: WaitingChatCell.self, with: chat, for: indexPath)
            case .activeChats:
                return self.configure(cellType: ActiveChatCell.self, with: chat, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = { [weak self]
            collectionView,
            kind,
            indexPath in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Cannot create new supplementary") }
            
            // todo: возможно, переделать как в PeopleVC
            guard let firstChat = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstChat) else { return nil }
            
            sectionHeader.configure(
                text: section.description(),
                font: .laoSangamMN20(),
                textColor: #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1))
            return sectionHeader
            
        }
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MChat>()

        snapshot.appendSections([.waitingChats])
        snapshot.appendItems(whaitingChats, toSection: .waitingChats)
        
        snapshot.appendSections([.activeChats])
        snapshot.appendItems(activeChats, toSection: .activeChats)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Setup Layout
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionIndex)
            else { fatalError("Unknown section kind") }
            
            switch section {
            case .waitingChats:
                return self.createWaitingChatSection(using: section)
            case .activeChats:
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
    func createWaitingChatSection(using section: Section) -> NSCollectionLayoutSection {
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
    
    func createActiveChatSection(using section: Section) -> NSCollectionLayoutSection {
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

// MARK: - Actions
extension ListViewController {
    @objc private func signOut() {
      let ac = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      ac.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
        do {
          try Auth.auth().signOut()
            UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
        } catch {
          print("Error signing out: \(error.localizedDescription)")
        }
      }))
      present(ac, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate
extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let chat = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        
        guard let section = Section(rawValue: indexPath.section)
            else { fatalError("Unknown section kind") }
        
        switch section {
        case .waitingChats:
            print(chat.friendUsername)
        case .activeChats:
            print(chat.lastMessageContent)
            let currentUser = MUser(username: "Me",
                                    avatarStringURL: "human3",
                                    email: "gtgt",
                                    description: "3232",
                                    sex: "male")
            let chatsVC = ChatsViewController(user: currentUser, chat: chat)
            navigationController?.pushViewController(chatsVC, animated: true)
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
