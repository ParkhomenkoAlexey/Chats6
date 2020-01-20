//
//  ChatPresenter.swift
//  Chats
//
//  Created by Алексей Пархоменко on 20.01.2020.
//  Copyright (c) 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

protocol ChatPresentationLogic {
  func presentData(response: Chat.Model.Response.ResponseType)
}

class ChatPresenter: ChatPresentationLogic {
  weak var viewController: ChatDisplayLogic?
  
  func presentData(response: Chat.Model.Response.ResponseType) {
  
  }
  
}
