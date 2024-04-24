//
//  EditProfileViewController.swift
//  IFriends
//
//  Created by Daniel Webster on 4/23/24.
//

import UIKit
import PhotosUI
import ParseSwift

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var confirmChangesButton: UIBarButtonItem!
    
    @IBOutlet weak var newProfilePicture: UIImageView!
    
    private var pickedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onSelectPictureTapped(_ sender: Any) {
        // Create a configuration object
        var config = PHPickerConfiguration()

        // Set the filter to only show images as options (i.e. no videos, etc.).
        config.filter = .images

        // Request the original file format. Fastest method as it avoids transcoding.
        config.preferredAssetRepresentationMode = .current

        // Only allow 1 image to be selected at a time.
        config.selectionLimit = 1

        // Instantiate a picker, passing in the configuration.
        let picker = PHPickerViewController(configuration: config)

        // Set the picker delegate so we can receive whatever image the user picks.
        picker.delegate = self

        // Present the picker
        present(picker, animated: true)
    }
    
    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    
    @IBAction func onConfirmChangesTapped(_ sender: Any) {
        // Unwrap optional pickedImage
        guard let image = pickedImage,
              // Create and compress image data (jpeg) from UIImage
              let imageData = image.jpegData(compressionQuality: 0.1) else {
            return
        }

        // Create a Parse File by providing a name and passing in the image data
        let imageFile = ParseFile(name: "image.jpg", data: imageData)

        DispatchQueue.main.async {
            if var currentUser = User.current {
                currentUser.profilePicture = imageFile
                currentUser.save { result in
                    switch result {
                    case .success:
                        print("User was updated successfully.")
                    case .failure(let error):
                        print("Error updating user: \(error)")
                    }
                }
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // Dismiss the picker
        picker.dismiss(animated: true)
        
        // Make sure we have a non-nil item provider
        guard let provider = results.first?.itemProvider,
              // Make sure the provider can load a UIImage
              provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        // Load a UIImage from the provider
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            
            // Make sure we can cast the returned object to a UIImage
            guard let image = object as? UIImage else {
                
                // ❌ Unable to cast to UIImage
                self?.showAlert()
                return
            }
            
            // Check for and handle any errors
            if let error = error {
                self?.showAlert(description: error.localizedDescription)
                return
            } else {
                
                // UI updates (like setting image on image view) should be done on main thread
                DispatchQueue.main.async {
                    
                    // Set image on preview image view
                    self?.newProfilePicture.image = image
                    
                    // Set image to use when saving post
                    self?.pickedImage = image
                }
            }
        }
    }
}
