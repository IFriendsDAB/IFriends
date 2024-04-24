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
        // Do any additional setup after loading the view.
        
        // user test
        guard let currentUser = User.current else {
                   print("User cannot be found")
                   return
               }
        
        DispatchQueue.main.async {
                if let fullName = currentUser.fullname {
                    self.fullname.text = fullName
                }
                
                if let username = currentUser.username {
                    self.username.text = username
                }
            }
        
        
        
        
        
        // Image
        if let imageFile = User.current?.profilePicture {
            if let imageUrl = imageFile.url {
                print("Image URL: \(imageUrl)")
            } else {
                print("No URL found for the image.")
            }
        } else {
            print("No profile picture is associated with the user.")
        }
        
        if let imageFile = User.current?.profilePicture,
           let imageUrl = imageFile.url {
            
            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    DispatchQueue.main.async {  // Ensure UI updates are on the main thread
                        self?.profilePicture.image = image
                    }
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }
        
    }
}
