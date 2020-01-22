//
//  AuthService.swift
//  Chats
//
//  Created by Алексей Пархоменко on 22.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

class AuthService {
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    
    func login(email: String?, password: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let email = email, let password = password else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        auth.signIn(withEmail: email, password: password) { (result, error) in
            guard result != nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(Void()))
            
        }
    }
    
    func googleLogin(user: GIDGoogleUser!, error: Error!, completion: @escaping (Result<Void, Error>) -> Void) {
        if let _ = error {
            completion(.failure(error))
            return
        }
        
        guard let auth = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            guard result != nil else {
                completion(.failure(error!))
                return
            }
        
            completion(.success(Void()))
        }
    }
    
    func register(email: String?, password: String?, confirmPassword: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard Validators.isFilled(email: email, password: password, confirmPassword: confirmPassword) else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        let email = email!
        let password = password!
        let confirmPassword = confirmPassword!
        
        guard password.lowercased() == confirmPassword.lowercased() else {
            completion(.failure(AuthError.passwordsNotMatched))
            return
        }

        guard Validators.isSimpleEmail(email) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }

        auth.createUser(withEmail: email, password: password) { (result, error) in
            guard let _ = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(Void()))
        } // createUser
    } // register
}

