//
//  ProfileViewModel.swift
//  New
//
//  Created by Dmytro Yurchenko on 22.03.2023.
//

import Foundation

protocol ProfileViewProtocol: AnyObject {
    func showErrorMessage(_ message: String)
}

protocol ProfileViewModelProtocol {
    func logout()
}

class ProfileViewModel: ProfileViewModelProtocol {
    
    var view: ProfileViewProtocol?
    var username: String?
    
    private let authService: AuthServiceProtocol
    
    init(username: String) {
        self.authService = AuthService()
        self.username = username
    }
    
    func logout() {
        
        return
    }
}
