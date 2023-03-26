//
//  RegistrationViewController.swift
//  New
//
//  Created by Dmytro Yurchenko on 22.03.2023.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var privacyPolicy: UITextView!
    
    private var viewModel: RegistrationViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = RegistrationViewModel(view: self)
        self.setup()
    }
    
    private func setup() {
        navigationItem.title = "Registration"
        register.addTarget(self, action: #selector(regiterTap), for: .touchUpInside)
        
        let policyText = "By registering, you agree to Privacy Policy"
        let attributedPolicyText = NSMutableAttributedString(string: policyText)
        let policyRange = (policyText as NSString).range(of: "Privacy Policy")
        attributedPolicyText.addAttribute(.link, value: "https://google.com", range: policyRange)
        
        privacyPolicy.attributedText = attributedPolicyText
        privacyPolicy.textAlignment = .center
    }
    
    @objc private func regiterTap() {
        let username = username.text ?? ""
        let password = password.text ?? ""
        
        if !username.isEmpty && !password.isEmpty {
            self.viewModel?.register(username: username, password: password)
        }
    }
}

extension RegistrationViewController: RegistrationViewProtocol {
    func registerSuccessful(username: String) {
        
        self.username.text = ""
        self.password.text = ""
        
        let model = ProfileViewModel(username: username)
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

extension RegistrationViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
