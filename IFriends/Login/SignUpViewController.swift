//
//  SignUpViewController.swift
//  IFriends
//
//  Created by Barsha Chaudhary on 4/22/24.
//

import UIKit
import Foundation

class SignUpViewController: UIViewController {

    @IBOutlet weak var fullnameSignUpField: UITextField!
    @IBOutlet weak var usernameSignupField: UITextField!
    @IBOutlet weak var countrySignUpField: UITextField!
    @IBOutlet weak var passwordSignUpField: UITextField!
    @IBOutlet weak var emailSignUpField: UITextField!
    var countryPickerView = UIPickerView()
    var countries: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordSignUpField.isSecureTextEntry = true
        selectOnCountry()
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
    
    private func selectOnCountry() {

        for code in NSLocale.isoCountryCodes  {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
        }
        countrySignUpField.inputView = countryPickerView
        countrySignUpField.placeholder = "Select Home Country"
        
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        
        countryPickerView.tag = 1
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

extension SignUpViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countrySignUpField.text = countries[row]
        countrySignUpField.resignFirstResponder()
    }
    
}
