//
//  SearchViewController.swift
//  IFriends
//
//  Created by Daniel Webster on 4/24/24.
//

import UIKit
import Alamofire
import AlamofireImage
import ParseSwift

private var imageDataRequest: DataRequest?

class SearchViewController: UIViewController {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var profileView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        findUser()

        
    }
    
    private func findUser(completion: (() -> Void)? = nil) {
        profileView.layer.cornerRadius = 10
        let searchUsername : String = SearchDetail.detail.username
        SearchDetail.detail = SearchDetail()
        let query = User.query()
            .where("username" == searchUsername)
            .limit(1)
        query.find { [weak self] result in
            switch result {
            case .success(let searchedUser):
                // Check if user was found (not an empty array)
                if let user = searchedUser.first {
                    print("User data found.")
                    DispatchQueue.main.async {
                        self?.fullname.text = user.fullname
                        self?.username.text = "@" + (user.username ?? "no username")
                        self?.country.text = user.country
                        self?.updateProfilePicture(user)
                    }
                } else {
                    print("User not found.")
                    DispatchQueue.main.async {
                        self?.profilePicture.image = UIImage(named: "defaultprofile")
                        self?.fullname.text = ""
                        self?.username.text = ""
                        self?.country.text = ""
                        self?.showAlert(description: "Username not found.")  // More specific error message
                    }
                }
            case .failure(let error):
                print("Error fetching user: \(error.localizedDescription)")
                // Handle error as before
            }
            completion?()
        }
    }

    private func updateProfilePicture(_ user: User) {
        guard let imageFile = user.profilePicture, let imageUrl = imageFile.url else {
            profilePicture.image = UIImage(named: "defaultprofile")
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
    
    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

}
