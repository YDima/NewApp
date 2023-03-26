//
//  RegistrationViewModel.swift
//  New
//
//  Created by Dmytro Yurchenko on 22.03.2023.
//

import Foundation

protocol RegistrationViewProtocol: AnyObject {
    func showErrorMessage(_ message: String)
    func registerSuccessful(username: String)
}

protocol RegistrationViewModelProtocol {
    init(view: RegistrationViewProtocol)
    func register(username: String, password: String)
}

class RegistrationViewModel: RegistrationViewModelProtocol {
    
    private weak var view: RegistrationViewProtocol?
    private let authService: AuthServiceProtocol
    
    required init(view: RegistrationViewProtocol) {
        self.view = view
        self.authService = AuthService()
    }
    
    func register(username: String, password: String) {
        self.authService.register(username: username, password: password) { result in
            switch result {
            case .success(let login):
                self.view?.registerSuccessful(username: login)
            case .failure(let error):
                self.view?.showErrorMessage(error.message)
            }
        }
    }
}
