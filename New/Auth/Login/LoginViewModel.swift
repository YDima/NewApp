//
//  LoginViewModel.swift
//  New
//
//  Created by Dmytro Yurchenko on 22.03.2023.
//

import Foundation

protocol LoginViewProtocol: AnyObject {
    func showErrorMessage(_ message: String)
    func loginSuccessful(login: String)
}

protocol LoginViewModelProtocol {
    init(view: LoginViewProtocol)
    func login(username: String, password: String)
}

class LoginViewModel: LoginViewModelProtocol {
    
    private weak var view: LoginViewProtocol?
    private let authService: AuthServiceProtocol
    
    required init(view: LoginViewProtocol) {
        self.view = view
        self.authService = AuthService()
    }
    
    func login(username: String, password: String) {
        self.authService.login(username: username, password: password) { result in
            switch result {
            case .success(let username):
                self.view?.loginSuccessful(login: username)
            case .failure(let error):
                self.view?.showErrorMessage(error.message)
            }
        }
    }
}
