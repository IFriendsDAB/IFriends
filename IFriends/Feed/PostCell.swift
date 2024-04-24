//
//  PostCell.swift
//  IFriends
//
//  Created by Barsha Chaudhary on 4/23/24.
//

import UIKit
import UIKit
import Alamofire
import AlamofireImage

class PostCell: UITableViewCell {

//    @IBOutlet weak var usernamePost: UILabel!
//    
//    @IBOutlet weak var imagePost: UIImageView!
//    @IBOutlet weak var datePost: UILabel!
//    @IBOutlet weak var captionPost: UILabel!
//    @IBOutlet weak var timeagoPost: UILabel!
//    
//    @IBOutlet weak var profilePicture: UIImageView!
    var imageDataRequest: DataRequest?
    
    @IBOutlet weak var usernamePost: UILabel!
    @IBOutlet weak var datePost: UILabel!
    @IBOutlet weak var captionPost: UILabel!
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var timeagoPost: UILabel!
    @IBOutlet weak var profilePIcture: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    var post: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupLikeGesture()
    }
    
    private func setupLikeGesture() {
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleLikeTap))
        likeImageView.isUserInteractionEnabled = true
        likeImageView.addGestureRecognizer(likeTap)
    }
    
    @objc func handleLikeTap() {
        guard let post = post else { return }
        toggleLike(for: post)
    }
    
    func toggleLike(for post: Post) {
        guard let currentUserObjectId = User.current?.objectId else { return }
        var mutablePost = post
        
        if mutablePost.likedBy.contains(currentUserObjectId) {
            mutablePost.likesCount -= 1
            mutablePost.likedBy.removeAll { $0 == currentUserObjectId }
            likeImageView.image = UIImage(named: "thumbs_up")  // Set unliked state image
        } else {
            mutablePost.likesCount += 1
            mutablePost.likedBy.append(currentUserObjectId)
            likeImageView.image = UIImage(named: "thumbs_up_filled")  // Set liked state image
        }
        
        saveUpdatedPost(mutablePost)
    }
    
    func saveUpdatedPost(_ post: Post) {
        post.save { [weak self] result in
            switch result {
            case .success(let updatedPost):
                DispatchQueue.main.async {
                    self?.post = updatedPost  // Update the local reference with the saved post
                    self?.configure(with: updatedPost)  // Reconfigure the cell with the new post data
                }
            case .failure(let error):
                print("Failed to update post: \(error.localizedDescription)")
            }
        }
    }
    
    
    func configure(with post: Post){
        if let user = post.user {
            usernamePost.text = user.username
        }
        // Image
        if let imageFile = post.imageFile, let imageUrl = imageFile.url {
            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    print("IMAGE PRINTED!")
                    print(imageUrl)
                    self?.imagePost.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    // You can also print the full error for more details
                    print("Full error: \(error)")
                }
            }
        }
        //profile Image
        if let imageFile = post.user?.profilePicture, let imageUrl = imageFile.url {
            // Use AlamofireImage helper to fetch remote image from URL
            profilePIcture.contentMode = .scaleAspectFill
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    print("IMAGE PRINTED!")
                    print(imageUrl)
                    self?.profilePIcture.image = image
                case .failure(let error):
                    print("❌ Error fetching profile image: \(error.localizedDescription)")
                    // You can also print the full error for more details
                    print("Full error: \(error)")
                }
            }
        }
        
        // Code to round the profile picture
        profilePIcture.layer.cornerRadius = 25
        profilePIcture.clipsToBounds = true
        profilePIcture.layer.borderColor = UIColor.blue.cgColor
        captionPost.text = post.caption
        
        if let date = post.createdAt{
            datePost.text = DateFormatter.postFormatter.string(from: date)
        }
        
        if let currentUser = User.current,
           let lastPostedDate = currentUser.lastPostedDate,
           let postCreatedDate = post.createdAt {
            // Code to execute if all optionals are successfully unwrapped
            // For example, comparing dates or updating UI
            print("Last posted: \(lastPostedDate), Post created: \(postCreatedDate)")
        }

    }

}

extension DateFormatter {
    static let postFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm" // Customize the format string as needed
        formatter.timeZone = TimeZone.current // Set the appropriate time zone
        formatter.locale = Locale.current // Set the locale if necessary
        return formatter
    }()
}

