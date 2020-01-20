//
//  ChatViewController.swift
//  Chats
//
//  Created by Алексей Пархоменко on 20.01.2020.
//  Copyright (c) 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

protocol ChatDisplayLogic: class {
    func displayData(viewModel: Chat.Model.ViewModel.ViewModelData)
}

class ChatViewController: UIViewController, ChatDisplayLogic {
    
    enum Section: CaseIterable {
        case main
    }
    
    var interactor: ChatBusinessLogic?
    var router: (NSObjectProtocol & ChatRoutingLogic)?
    
    var dataSource: UITableViewDiffableDataSource<Section, MMessage>!
    var tableView: UITableView!
    
    private let user: UsersController.MUser
    private let chat: MChat
    
    init(user: UsersController.MUser, chat: MChat) {
        self.user = user
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
        
        title = chat.friendName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setup() {
        let viewController        = self
        let interactor            = ChatInteractor()
        let presenter             = ChatPresenter()
        let router                = ChatRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureHierarchy()
        configureDataSource()
    }
    
    func displayData(viewModel: Chat.Model.ViewModel.ViewModelData) {
        
    }
}

// MARK: - Helper Functions
extension ChatViewController {
    func currentSender() -> UsersController.MUser {
        return UsersController.MUser(username: user.username, avatarStringURL: user.avatarStringURL, sex: user.sex)
    }
}

// MARK: - Setup TableView Layout
extension ChatViewController {
    func configureHierarchy() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseId)
        tableView.separatorStyle = .none
    }
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, MMessage>(tableView: tableView) { (tableView, indexPath, message) -> UITableViewCell? in
            if let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseId) as? MessageCell {
                cell.set(message: message)
                return cell
            } else {
                fatalError()
            }
        }
        
        // initial data
        
        let snapshot = initialSnapshot()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func initialSnapshot() -> NSDiffableDataSourceSnapshot<Section, MMessage> {
        let messages: [MMessage] = [
            MMessage(content: "Hello", senderName: "Alex"),
            MMessage(content: "How are you?", senderName: "Bob")
        ]
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, MMessage>()
        snapshot.appendSections([.main])
        
        snapshot.appendItems(messages)
        return snapshot
    }
}

// MARK: - SwiftUI
import SwiftUI
struct ChatProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let chatVC: MainTabBarController = MainTabBarController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<ChatProvider.ContainterView>) -> MainTabBarController {
            return chatVC
        }
        
        func updateUIViewController(_ uiViewController: ChatProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<ChatProvider.ContainterView>) {
            
        }
    }
}
