//
//  ViewController.swift
//  IFriends
//
//  Created by Amir Ince on 4/9/24.
//

import UIKit
import ParseSwift

class FeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    private var posts = [Post]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
//        refreshControl.tintColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryPosts()
    }
    
    private func queryPosts(completion: (() -> Void)? = nil) {
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: (-1), to: Date())!
        let query = Post.query()
            .include(["user"])
            .order([.descending("createdAt")])
            .where("createdAt" >= yesterdayDate)
            .limit(10)
        query.find{[weak self] result in
            switch result {
            case .success(let posts):
                print("Fetched posts: \(posts)")
                self?.posts = posts
            case .failure(let error):
                print("Error fetching posts: \(error.localizedDescription)")
                self?.showAlert(description: error.localizedDescription)
            }
            completion?()
        }
    }
    
    @objc private func onPullToRefresh() {
        refreshControl.beginRefreshing()
        queryPosts { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCommentsSegue",
           let commentVC = segue.destination as? CommentViewController,
           let postId = sender as? String {
            commentVC.currentPostId = postId
        } else {
            print("Segue identifier not matched or sender is not a String")
        }
    }
    
}


extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
                return UITableViewCell()
            }
            cell.configure(with: posts[indexPath.row])
            cell.delegate = self
            return cell
    }
}

extension FeedViewController: UITableViewDelegate { }

extension FeedViewController: PostCellDelegate {
    func didTapCommentButton(postId: String) {
        print("Delegate method called with postId: \(postId)")
        performSegue(withIdentifier: "ShowCommentsSegue", sender: postId)
    }
}



