//
//  ChatsViewController.swift
//  Chats
//
//  Created by Алексей Пархоменко on 21.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import FirebaseFirestore
import InputBarAccessoryView
import Photos

class ChatsViewController: MessagesViewController {
    
    private let user: MUser
    private let chat: MChat
    
    init(user: MUser, chat: MChat) {
        self.user = user
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
        
        title = chat.friendUsername
    }
    
    private var messages: [MMessage] = []
    private var messageListener: ListenerRegistration?
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    deinit {
      messageListener?.remove()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // убираем avatarVIew
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
        }
        
        messagesCollectionView.backgroundColor = .mainWhite()
        
        maintainPositionOnKeyboardFrameChanged = true
        configureMessageInputBar()
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageListener = ListenerService.shared.messagesObserve(chat: chat, completion: { (result) in
            switch result {
            case .success(let message):
                self.insertNewMessage(message: message)
            case .failure(let error):
                self.showAlert(with: "Ошибка!", and: error.localizedDescription)
            }
        })
    }
    
    
    
    private func insertNewMessage(message: MMessage) {
        guard !messages.contains(message) else { return }
        
        messages.append(message)
        messages.sort()
        
        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
//    // MARK: - Actions
//
//    @objc private func cameraButtonPressed() {
//      let picker = UIImagePickerController()
//      picker.delegate = self
//
//      if UIImagePickerController.isSourceTypeAvailable(.camera) {
//        picker.sourceType = .camera
//      } else {
//        picker.sourceType = .photoLibrary
//      }
//
//      present(picker, animated: true, completion: nil)
//    }
}


// MARK: - ConfigureMessageInputBar
extension ChatsViewController {
    func configureMessageInputBar() {

        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.backgroundView.backgroundColor = .mainWhite()
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 36, bottom: 14, right: 36)
        messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 0.4033635232)
        messageInputBar.inputTextView.layer.borderWidth = 0.2
        messageInputBar.inputTextView.layer.cornerRadius = 18.0
//        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        
        
        messageInputBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        messageInputBar.layer.shadowRadius = 5
        messageInputBar.layer.shadowOpacity = 0.3
        messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        configureSendButton()
//        configureCameraIcon()
    }
    
    func configureSendButton() {
        messageInputBar.sendButton.setImage(UIImage(named: "Sent"), for: .normal)
        messageInputBar.sendButton.applyGradients(cornerRadius: 10)
        messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
        messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
        messageInputBar.middleContentViewPadding.right = -38
    }
    
//    func configureCameraIcon() {
//        // 1
//        let cameraItem = InputBarButtonItem(type: .system)
//        cameraItem.tintColor = .red
//        cameraItem.image = #imageLiteral(resourceName: "camera")
//
//        // 2
//        cameraItem.addTarget(
//          self,
//          action: #selector(cameraButtonPressed),
//          for: .primaryActionTriggered
//        )
//        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
//
//        messageInputBar.leftStackView.alignment = .center
//        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
//
//        // 3
//        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
//    }
}

// MARK: - MessagesDataSource
extension ChatsViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: user.identifier, displayName: user.username)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.item]
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        print("4343")
        if indexPath.item % 4 == 0 {
            print("whaaa")
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
}

// MARK: - MessagesLayoutDelegate
extension ChatsViewController: MessagesLayoutDelegate {
    
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if (indexPath.item) % 4 == 0 {
            return 30
        }
        return 0
    }
}

// MARK: - MessagesDisplayDelegate
extension ChatsViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2392156863, alpha: 1) : .white
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
        
    }
    
    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
     
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

        return .bubble
    }
    
}

// MARK: - InputBarAccessoryViewDelegate
extension ChatsViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = MMessage(user: user, content: text)
        FirestoreService.shared.sendMessage(chat: chat, message: message) { (result) in
            switch result {
            case .success:
                self.messagesCollectionView.scrollToBottom()
            case .failure(_):
                self.showAlert(with: "Ошибка!", and: "Сообщение не доставлено")
            }
        }
        
        inputBar.inputTextView.text = ""
    }
}

// MARK: - SwiftUI
import SwiftUI
struct ChatsProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let chatsVC: ChatsViewController = ChatsViewController(
            user: MUser(username: "Abla",avatarStringURL: "human1", email: "3232", description: "3232", sex: "male"),
            chat: MChat(friendUsername: "ffrfr", friendAvatarStringURL: "fefe", friendIdentifier: "fefe", lastMessageContent: "fdf"))
        func makeUIViewController(context: UIViewControllerRepresentableContext<ChatsProvider.ContainterView>) -> ChatsViewController {
            return chatsVC
        }
        
        func updateUIViewController(_ uiViewController: ChatsProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<ChatsProvider.ContainterView>) {
            
        }
    }
}
