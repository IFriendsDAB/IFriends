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
        print("Like tapped")
        guard let post = post else{
            print("print post is nil")
            return
        }
        toggleLike(for: post)
    }
    
    func toggleLike(for post: Post) {
        guard let currentUserObjectId = User.current?.objectId else { return }
        var mutablePost = post
        
        
        if mutablePost.likedBy.contains(currentUserObjectId) {
            print("Current User Object ID: \(currentUserObjectId)")
            mutablePost.likesCount -= 1
            mutablePost.likedBy.removeAll { $0 == currentUserObjectId }
            likeImageView.image = UIImage(named: "thumps_up")  // Set unliked state image
            print("thumps up working")
        } else {
            mutablePost.likesCount += 1
            mutablePost.likedBy.append(currentUserObjectId)
            DispatchQueue.main.async {
                if let image = UIImage(named: "thumps_up_filled") {
                    self.likeImageView.image = image
                    print("Image loaded successfully")
                } else {
                    print("Failed to load image")
                }
            }
        }
        
        self.post = mutablePost  // Update the local reference immediately
        configure(with: mutablePost)  // Reconfigure immediately to reflect changes
        
        saveUpdatedPost(mutablePost)  // Save the changes asynchronously
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
        self.post = post
        if let user = post.user {
            usernamePost.text = user.username
        }
        
        if let currentUserObjectId = User.current?.objectId,
           post.likedBy.contains(currentUserObjectId) {
            likeImageView.image = UIImage(named: "thumps_up_filled") // User has liked this post
        } else {
            likeImageView.image = UIImage(named: "thumps_up") // User has not liked this post
        }
        
        
        // Image
        if let imageFile = post.imageFile, let imageUrl = imageFile.url {
            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
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
                    self?.profilePIcture.image = image
                case .failure(let error):
                    print("❌ Error fetching profile image: \(error.localizedDescription)")
                    // You can also print the full error for more details
                    print("Full error: \(error)")
                }
            }
        }
        
        // Code to round the profile picture
        profilePIcture.layer.cornerRadius = profilePIcture.frame.height / 2
        profilePIcture.clipsToBounds = true
        profilePIcture.layer.borderColor = UIColor.blue.cgColor
        captionPost.text = post.caption
        
        if let date = post.createdAt{
            datePost.text = DateFormatter.postFormatter.string(from: date)
        }
        likesLabel.text = "\(post.likesCount) likes"
        
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

