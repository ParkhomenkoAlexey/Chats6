//
//  ChatInteractor.swift
//  Chats
//
//  Created by Алексей Пархоменко on 20.01.2020.
//  Copyright (c) 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

protocol ChatBusinessLogic {
  func makeRequest(request: Chat.Model.Request.RequestType)
}

class ChatInteractor: ChatBusinessLogic {

  var presenter: ChatPresentationLogic?
  var service: ChatService?
  
  func makeRequest(request: Chat.Model.Request.RequestType) {
    if service == nil {
      service = ChatService()
    }
  }
  
}
