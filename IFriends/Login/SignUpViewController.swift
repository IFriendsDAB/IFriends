//
//  SignUpViewController.swift
//  IFriends
//
//  Created by Barsha Chaudhary on 4/22/24.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var fullnameSignUpField: UITextField!
    @IBOutlet weak var usernameSignupField: UITextField!
    @IBOutlet weak var countrySignUpField: UITextField!
    @IBOutlet weak var passwordSignUpField: UITextField!
    @IBOutlet weak var emailSignUpField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordSignUpField.isSecureTextEntry = true
    }
    

    @IBAction func onSignUpTapped(_ sender: Any) {
        guard let username = usernameSignupField.text,
              let password = passwordSignUpField.text,
              let email = emailSignUpField.text,
              let fullname = fullnameSignUpField.text,
              let country = countrySignUpField.text,
              !username.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !fullname.isEmpty,
              !country.isEmpty else {
            showMissingFieldsAlert()
            return
        }
        
        var newUser = User()
        newUser.username = username
        newUser.password = password
        newUser.email = email
        newUser.fullname = fullname
        newUser.country = country
        
        newUser.signup{[weak self] result in
            switch result {
            case .success(let user):
                print("✅ Successfully signed up user \(user)")
                
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
        }
    }
    
    private func showAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Sign Up", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Opps...", message: "We need all fields filled out in order to sign you up.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
}
