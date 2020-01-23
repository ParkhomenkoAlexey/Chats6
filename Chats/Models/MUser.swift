//
//  MUser.swift
//  Chats
//
//  Created by Алексей Пархоменко on 10.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

class UsersController {
    struct MUser: Decodable, Hashable {
        var username: String
        var email: String
        var avatarStringURL: String
        var description: String
        var sex: String
        var identifier: String
        
        init(username: String, avatarStringURL: String,
             email: String, description: String,
             sex: String, identifier: String = UUID().uuidString) {
            self.username = username
            self.email = email
            self.avatarStringURL = avatarStringURL
            self.description = description
            self.sex = sex
            self.identifier = identifier
        }
        
        init?(document: DocumentSnapshot) {
            guard let data = document.data() else { return nil }
            guard let username = data["username"] as? String,
                let email = data["email"] as? String,
                let avatarStringURL = data["avatarStringURL"] as? String,
                let description = data["description"] as? String,
                let sex = data["sex"] as? String,
                let identifier = data["uid"] as? String else {
                    return nil
            }
            self.username = username
            self.email = email
            self.avatarStringURL = avatarStringURL
            self.description = description
            self.sex = sex
            self.identifier = identifier
        }
        
        var representation: [String : Any] {
            var rep = ["username": username]
            rep["sex"] = sex
            rep["email"] = email
            rep["avatarStringURL"] = avatarStringURL
            rep["description"] = description
            rep["sex"] = sex
            rep["uid"] = identifier
            return rep
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        static func == (lhs: MUser, rhs: MUser) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        
        func contains(_ filter: String?) -> Bool {
            guard let filterText = filter else { return true }
            if filterText.isEmpty { return true }
            let lowercasedFilter = filterText.lowercased()
            return username.lowercased().contains(lowercasedFilter)
        }
    }
    
    func filteredUsers(with searchText: String?=nil, limit: Int?=nil) -> [MUser] {
        let filtered = users.filter { $0.contains(searchText) }
        if let limit = limit {
            return Array(filtered.prefix(through: limit))
        } else {
            return filtered
        }
    }
    
    private lazy var users: [MUser] = {
        return Bundle.main.decode([MUser].self, from: "users.json")
    }()
}



