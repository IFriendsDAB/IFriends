//
//  CommentCell.swift
//  IFriends
//
//  Created by Barsha Chaudhary on 4/25/24.
//

import UIKit
import Alamofire
import AlamofireImage

class CommentCell: UITableViewCell {
    var imageDataRequest: DataRequest?

    @IBOutlet weak var commentatorImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var noCommentHolder: UILabel!
    @IBOutlet weak var commentatorName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        commentatorImage.layer.cornerRadius = commentatorImage.frame.height / 2
        commentatorImage.clipsToBounds = true
    }
    
    func configureWithComment(_ comment: Comment) {
        // Hide the placeholder and show the comment elements
        noCommentHolder.isHidden = true
        commentLabel.isHidden = false
        commentatorName.isHidden = false
        commentatorImage.isHidden = false

        commentLabel.text = comment.comment
        commentatorName.text = comment.user?.username

        //profile Image
        if let imageFile = comment.user?.profilePicture, let imageUrl = imageFile.url {
            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.commentatorImage.image = image
                case .failure(let error):
                    print("❌ Error fetching profile image: \(error.localizedDescription)")
                    // You can also print the full error for more details
                    print("Full error: \(error)")
                }
            }
        }
        

        
    }

    func showNoCommentsPlaceholder() {
        // Show the placeholder and hide other elements
        noCommentHolder.isHidden = false
        commentLabel.isHidden = true
        commentatorName.isHidden = true
        commentatorImage.isHidden = true

        noCommentHolder.text = "No comments yet on this post"
    }
    
    
}
