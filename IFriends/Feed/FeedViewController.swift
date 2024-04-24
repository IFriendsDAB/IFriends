//
//  ViewController.swift
//  IFriends
//
//  Created by Amir Ince on 4/9/24.
//

import UIKit
import ParseSwift

class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onTappedLogout(_ sender: Any) {
        showConfirmLogoutAlert()
    }
    
    private func showConfirmLogoutAlert() {
        let alertController = UIAlertController(title: "Log out of your account?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
}

