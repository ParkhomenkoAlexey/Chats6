//
//  PeopleViewController.swift
//  Chats
//
//  Created by Алексей Пархоменко on 10.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit
import FirebaseFirestore

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
    
    private var users: [MUser] = []
    private var userListener: ListenerRegistration?
    private var userReference: CollectionReference {
      return Firestore.firestore().collection("users")
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MUser>!
    var collectionView: UICollectionView! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, MUser>! = nil
    
    private let currentUser: MUser
    
    init(currentUser: MUser = MUser(username: "dfd", avatarStringURL: "fdf", email: "frgr", description: "frf", sex: "frfr", identifier: "fefe")) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    deinit {
        userListener?.remove()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupSearchBar()
        createDataSource()
        
        userListener = userReference.addSnapshotListener({ (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                guard let user = MUser(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    guard !self.users.contains(user) else { return }
                    guard user != self.currentUser else { return }
                    self.users.append(user)
                case .modified:
                    guard let index = self.users.firstIndex(of: user) else { return }
                    self.users[index] = user
                case .removed:
                    guard let index = self.users.firstIndex(of: user) else { return }
                    self.users.remove(at: index)
                }
            }
            self.reloadData(with: nil)
        })
    }
    
    // MARK: - Manage the data in UICV
    private func reloadData(with searchText: String?) {
        let filtered = users.filter { (user) -> Bool in
            user.contains(searchText)
        }
        
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, MUser>()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(filtered, toSection: .main)

        self.dataSource.apply(currentSnapshot, animatingDifferences: true)
    }

    
    func configure<T: SelfConfiguringCell, U: Hashable>(cellType: T.Type, with value: U, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else { fatalError("Unable to dequeue \(cellType)") }
        cell.configure(with: value)
        return cell
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MUser>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            
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
}

// MARK: Setup UI Elements
extension PeopleViewController {
    
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
        guard let user = self.dataSource.itemIdentifier(for: indexPath) else { return }
        let profileVC = ProfileViewController(user: user, currentUser: currentUser)
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
