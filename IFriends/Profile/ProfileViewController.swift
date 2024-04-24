//
//  ProfileViewController.swift
//  IFriends
//
//  Created by Daniel Webster on 4/23/24.
//

import UIKit
import Alamofire
import AlamofireImage

private var imageDataRequest: DataRequest?

class ProfileViewController: UIViewController {
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUserData()
        loadProfilePicture()
    }
        
    private func updateUserData() {
        guard let currentUser = User.current else {
            print("User cannot be found")
            return
        }
        
        DispatchQueue.main.async {
            self.fullname.text = currentUser.fullname
            self.username.text = currentUser.username
        }
        
        print("User:", currentUser.username ?? "No username available")
    }
    
    private func loadProfilePicture() {
        guard let imageFile = User.current?.profilePicture, let imageUrl = imageFile.url else {
            print("No profile picture is associated with the user or no URL found for the image.")
            return
        }
        
        print("Image URL: \(imageUrl)")
        
        // Use AlamofireImage to fetch the remote image from URL
        imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.profilePicture.image = image
                }
            case .failure(let error):
                print("❌ Error fetching image: \(error.localizedDescription)")
            }
        }
    }
        
    
}
