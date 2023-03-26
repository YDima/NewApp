//
//  AuthService.swift
//  New
//
//  Created by Dmytro Yurchenko on 22.03.2023.
//

import Foundation

protocol AuthServiceProtocol {
    func login(username: String, password: String, completion: @escaping (Result<String, AuthError>) -> Void)
    func register(username: String, password: String, completion: @escaping (Result<String, AuthError>) -> Void)
}

enum AuthError: Error {
    case noSuchUser
    case notMatching
    case alreadyCreated
    case unknown
    
    var message: String {
        switch self {
        case .noSuchUser:
            return "There is no such user."
        case .notMatching:
            return "Password is not correct."
        case .alreadyCreated:
            return "User already created."
        case .unknown:
            return "Unknown error"
        }
    }
}

class AuthService: AuthServiceProtocol {
    
    static let shared = AuthService()
    
    func login(username: String, password: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        guard let secret = Keychain.shared.getValue(for: username) else {
            completion(.failure(AuthError.noSuchUser))
            return
        }
        
        if secret == password {
            saveUser(username)
            completion(.success(username))
        } else {
            completion(.failure(AuthError.notMatching))
        }
        
        return
    }
    
    func register(username: String, password: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        if Keychain.shared.getValue(for: username) != nil {
            completion(.failure(AuthError.alreadyCreated))
            return
        }
        
        if Keychain.shared.setValue(password, for: username) {
            completion(.success(username))
        } else {
            completion(.failure(.unknown))
        }
    }
    
    private func saveUser(_ username: String) {
        UserDefaults().set(username, forKey: "username")
    }
}
