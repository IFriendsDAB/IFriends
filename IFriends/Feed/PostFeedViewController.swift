//
//  PostFeedViewController.swift
//  IFriends
//
//  Created by Barsha Chaudhary on 4/23/24.
//

import UIKit
import PhotosUI
import Alamofire
import AlamofireImage
import ParseSwift

private var imageDataRequest: DataRequest?

class PostFeedViewController: UIViewController, PHPickerViewControllerDelegate {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var previewImageView: UIImageView!
    var pickedImage: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUserData()
    }
    
    private func refreshUserData() {
        guard let currentUser = User.current else {
            print("No current user logged in")
            return
        }

        currentUser.fetch { [weak self] result in
            switch result {
            case .success(let updatedUser):
                print("User data refreshed successfully.")
                DispatchQueue.main.async {
                    self?.username.text = "@" + (updatedUser.username ?? "no username")
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
        profilePicture.layer.cornerRadius = 20
        profilePicture.clipsToBounds = true
        profilePicture.contentMode = .scaleAspectFill

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
    
    @IBAction func onPickedImageTapped(_ sender: Any) {
        var config = PHPickerConfiguration()
        
        //Set the filter to only show images as options
        config.filter = .images
        
        // Request the original file format
        config.preferredAssetRepresentationMode = .current
        
        //only allow 1 image to be selected at a time
        config.selectionLimit = 1
        
        //Instantiate a picker, passing in the configuration
        let picker = PHPickerViewController(configuration: config)
        
        //Set the picker delegate so we can receive whatever image the user picks
        picker.delegate = self
        present(picker, animated: true)
        
    }
 
    @IBAction func postTapped(_ sender: Any) {
        view.endEditing(true)
            
            guard let image = pickedImage, let imageData = image.jpegData(compressionQuality: 0.1) else {
                return
            }
            
            let imageFile = ParseFile(name: "image.jpg", data: imageData)
            var post = Post()
            post.caption = captionField.text
            post.imageFile = imageFile
            post.user = User.current

        post.save { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    print("Post Saved! \(post)")
                    self?.updateCurrentUser()
                    
                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
    }
    func updateCurrentUser() {
        guard var currentUser = User.current else { return }
        
        currentUser.lastPostedDate = Date()
        currentUser.save { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    print("✅ User Saved! \(user)")
                    self?.navigationController?.popViewController(animated: true)
                    
                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
    }
    
    func showAlert(description: String) {
        let alert = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self?.previewImageView.image = image
                        self?.pickedImage = image
                    } else if let error = error {
                        self?.showAlert(description: error.localizedDescription)
                    }
                }
            }
        }
    }
    
}
