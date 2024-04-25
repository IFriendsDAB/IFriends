//
//  ComposeNewMessage.swift
//  IFriends
//
//  Created by Amir Ince on 4/25/24.
//

import UIKit
import Alamofire
import AlamofireImage
import ParseSwift

class ComposeNewMessage: UIViewController {
    
    @IBOutlet weak var receiver_name: UITextField!
    @IBOutlet weak var message: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Class connected correctly")
    }
    
    
    @IBAction func didTapSend(_ sender: Any) {
        
        print("Login Button Tapped")
        
        // Checking that both fields have data
        guard let receiver = receiver_name.text,
              let mess = message.text,
                  !receiver.isEmpty,
                  !mess.isEmpty else{
                showMissingFieldsAlert()
                return
                }
        
        let searchUsername : String = receiver_name.text ?? "NA"
        SearchDetail.detail = SearchDetail()
        let query = User.query()
            .where("username" == searchUsername)
            .limit(1)
        query.find { [weak self] result in
            switch result {
            case .success(let searchedUser):
                // Check if user was found (not an empty array)
                if let user = searchedUser.first {
                    print("User found data found.")
                    print("Time to send the message")
                    
                    print(self?.receiver_name.text)
                    print(User.current?.username)
                    print(self?.message.text)
                    var messages = Messages()
                    
                    messages.sender = User.current?.username
                    messages.receiver = self?.receiver_name.text
                    messages.message = self?.message.text
                    
                    // Need to save the message to database now:
                    messages.save { [weak self] result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let post):
                                print("Message Saved! \(post)")
                                
                                // Function here to return to caller
                                
                                self?.navigationController?.popViewController(animated: true)
                                
                                
                            case .failure(let error):
                                self?.showAlert(description: error.localizedDescription)
                            }
                        }
                    }
                    
                } else {
                    print("User not found.")
                    self?.showAlert(description: "User not found")
                }
            case .failure(let error):
                print("Error fetching user: \(error.localizedDescription)")
                // Handle error as before
            }
        }
            
    }
    
    

    private func showAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable send message", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Oops", message: "We need all fields filled out in order to log you in.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
        }


}
