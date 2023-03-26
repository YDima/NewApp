//
//  ProfileViewController.swift
//  New
//
//  Created by Dmytro Yurchenko on 22.03.2023.
//

import UIKit

class ProfileViewController: UIViewController, UITabBarControllerDelegate {

    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var logout: UIButton!
    
    private var viewModel: ProfileViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        setup()
    }
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        navigationItem.title = "Profile"
        navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.welcome.text = "Hi✌️ \(viewModel.username ?? "sport")"
        self.logout.setTitle("Logout", for: .normal)
    }

    @IBAction func logoutTap(_ sender: Any) {
        UserDefaults().removeObject(forKey: "username")
        self.navigationController?.viewControllers = [LoginViewController()]
    }
    
}

extension ProfileViewController: ProfileViewProtocol {
    func showErrorMessage(_ message: String) {
        
        let alert = UIAlertController(title: "New", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { _ in
            return
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
