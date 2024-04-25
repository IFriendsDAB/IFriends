//
//  CommentViewController.swift
//  IFriends
//
//  Created by Barsha Chaudhary on 4/25/24.
//

import UIKit
import PhotosUI
import Alamofire
import AlamofireImage
import ParseSwift
private var imageDataRequest: DataRequest?
class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var currentPostId: String?
    @IBOutlet weak var commentInputField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var comments: [Comment] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(comments.count, 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else {
                    return UITableViewCell()  // Return an empty cell if something goes wrong
                }
        if comments.isEmpty {
            cell.showNoCommentsPlaceholder()
        } else {
            let comment = comments[indexPath.row]
            cell.configureWithComment(comment)
        }

        return cell
    }
    
    func didTapCommentButton(in cell: PostCell) {
        performSegue(withIdentifier: "showCommentDetails", sender: cell)
    }
    
    @IBAction func commentPostTapped(_ sender: Any) {
        guard let commentText = commentInputField.text, !commentText.isEmpty else {
                showAlert(message: "Comment field is empty or post is not identified.")
                return
            }
            guard let postId = self.currentPostId else {
                showAlert(message: "Post is not identified.")
                return
            }
            
            var newComment = Comment()
            newComment.comment = commentText
            newComment.user = User.current
            newComment.post = Pointer<Post>(objectId: postId)  // Ensure this matches your data model


            newComment.save { [weak self] result in
                // Hide loading indicator
                
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self?.commentInputField.text = ""
                        self?.commentInputField.resignFirstResponder()
                        self?.comments.insert(newComment, at: 0)
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    self?.showAlert(message: "Failed to post comment: \(error.localizedDescription)")
                }
            }
    }

    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func configureCell(_ cell: CommentCell, with comment: Comment, at indexPath: IndexPath) {
        cell.commentLabel.text = comment.comment
        cell.commentatorName.text = comment.user?.username

        // Check for profile picture and load it if available
        if let file = comment.profilePicture, let url = file.url {
            imageDataRequest = AF.request(url).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    DispatchQueue.main.async {
                        // Ensure that self is still around when the image fetch completes and the cell is visible
                        guard let strongSelf = self else { return }
                        // Check if the cell for the given indexPath is still visible
                        if let visibleRows = strongSelf.tableView.indexPathsForVisibleRows, visibleRows.contains(indexPath) {
                            // Update the image only if the cell is visible
                            cell.commentatorImage.image = image
                        }
                    }
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    // Optionally set a default error image or keep the placeholder
                    cell.commentatorImage.image = UIImage(named: "defaultImage")
                }
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if let postId = currentPostId {
                    loadComments(forPostId: postId)
                }
    }
    
    private func loadComments(forPostId postId: String) {
        guard let postId = self.currentPostId else {
            print("Post ID is not set.")
            return
        }
        print("Loading comments for postId: \(postId)")

        // Assuming Comment has a 'post' field that is a Pointer to a Post
        let postPointer = Pointer<Post>(objectId: postId)

        // Setup the query to match comments with the post pointer, include the user, and order by creation date
        var query = Comment.query("post" == postPointer)
        query = query.include("user")  // Include the User object related to each comment
        query = query.order([.descending("createdAt")])  // Sort comments from the newest to the oldest

        // Execute the query
        query.find { [weak self] result in
            switch result {
            case .success(let comments):
                DispatchQueue.main.async {
                    self?.comments = comments
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error fetching comments: \(error.localizedDescription)")
                    self?.showAlert(message: "Unable to load comments. Please try again later.")
                }
            }
        }
    }

    

}
