//
//  LoginViewController.swift
//  IFriends
//
//  Created by Barsha Chaudhary on 4/22/24.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordField.isSecureTextEntry = true

        // Do any additional setup after loading the view.
    }
    @IBAction func tappedLogin(_ sender: Any) {
        
        print("Login Button Tapped")
        guard let username = usernameField.text,
                      let password = passwordField.text,
                      !username.isEmpty,
                      !password.isEmpty else{
                    showMissingFieldsAlert()
                    return
        }
                
        User.login(username:username, password: password){[weak self] result in
            switch result {
            case .success(let user):
                print("✅ Successfully logged in as user: \(user)")
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
                
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
                    
        }
    }
    
    
    private func showAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Log in", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Opps...", message: "We need all fields filled out in order to log you in.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
}
