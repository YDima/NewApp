//
//  LoginViewController.swift
//  New
//
//  Created by Dmytro Yurchenko on 22.03.2023.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    
    private var viewModel: LoginViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = LoginViewModel(view: self)
        
        navigationItem.title = "Login"
        self.navigationItem.rightBarButtonItem = .init(title: "Register", style: .plain, target: self, action: #selector(openRegistration))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let user = UserDefaults().value(forKey: "username") as? String {
            self.loginSuccessful(login: user)
        }
        
        super.viewWillAppear(animated)
    }
    
    @IBAction func loginTap(_ sender: UIButton) {
        let username = self.username.text ?? ""
        let password = self.password.text ?? ""
        
        if !username.isEmpty && !password.isEmpty {
            self.viewModel?.login(username: username, password: password)
        }
    }
    
    @objc func openRegistration() {
        navigationController?.pushViewController(RegistrationViewController(), animated: true)
    }
}

extension LoginViewController: LoginViewProtocol {
    
    func loginSuccessful(login: String) {
        
        self.username.text = ""
        self.password.text = ""
        
        let model = ProfileViewModel(username: login)
        let profileViewController = ProfileViewController(viewModel: model)
        
        self.navigationController?.viewControllers = [profileViewController]
    }
    
    func showErrorMessage(_ message: String) {
        
        let alert = UIAlertController(title: "New", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { _ in
            return
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
