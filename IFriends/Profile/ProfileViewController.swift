//
//  ProfileViewController.swift
//  IFriends
//
//  Created by Daniel Webster on 4/23/24.
//

import UIKit
import Alamofire
import AlamofireImage
import ParseSwift

private var imageDataRequest: DataRequest?

class ProfileViewController: UIViewController {
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileInfoView: UIView!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var searchUserField: UITextField!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUserData()
    }
        
    private func refreshUserData() {
        guard let currentUser = User.current else {
            print("No current user logged in")
            return
        }
        profileInfoView.layer.cornerRadius = 10
        currentUser.fetch { [weak self] result in
            switch result {
            case .success(let updatedUser):
                print("User data refreshed successfully.")
                DispatchQueue.main.async {
                    self?.fullname.text = updatedUser.fullname
                    self?.username.text = "@" + (updatedUser.username ?? "no username")
                    self?.country.text = updatedUser.country
                    self?.updateProfilePicture(updatedUser)
                }
            case .failure(let error):
                print("Error refreshing user data: \(error.localizedDescription)")
            }
        }
    }

    private func updateProfilePicture(_ user: User) {
        guard let imageFile = user.profilePicture, let imageUrl = imageFile.url else {
            print("No profile picture is associated with the user or no URL found for the image.")
            return
        }
        profilePicture.layer.cornerRadius = 25
        profilePicture.clipsToBounds = true
        profilePicture.layer.borderColor = UIColor.blue.cgColor
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.layer.cornerRadius = profilePicture.frame.width / 2
        profilePicture.clipsToBounds = true
        profilePicture.layer.borderWidth = 3.0
        profilePicture.layer.borderColor = UIColor.white.cgColor

        imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
            switch response.result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.profilePicture.image = image
                }
            case .failure(let error):
                print("❌ Error fetching image: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func onSearchForUserTapped(_ sender: Any) {
        print("Tapped")
        SearchDetail.detail = SearchDetail()
        SearchDetail.detail.username = searchUserField.text ?? "no entry"
        print("Entered:", SearchDetail.detail.username)
        performSegue(withIdentifier: "goToSearchedUser", sender: self)
    }
    
    @IBAction func onLogoutTapped(_ sender: Any) {
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
