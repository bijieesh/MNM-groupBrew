//
//  CommentsViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/12/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable

class CommentsViewController: AppViewController {

    var onAddComment: ((String) -> Void)?

    var comments: [Comment] = []

    @IBOutlet private var commentsTableView: UITableView! {
        didSet {
            commentsTableView.estimatedRowHeight = 80
            commentsTableView.rowHeight = UITableView.automaticDimension
            commentsTableView.register(cellType: CommentCell.self)
            commentsTableView.tableFooterView = UIView()
        }
    }

    @IBAction private func addCommentPressed() {
        let alertController = UIAlertController(title: "Leave a comment", message: nil, preferredStyle: .alert)

        alertController.addTextField(configurationHandler: nil)

        alertController.addAction(UIAlertAction(title: "Comment", style: .default, handler: { [weak self] _ in
            guard let comment = alertController.textFields?.first?.text, !comment.isEmpty else {
                return
            }

            self?.onAddComment?(comment)
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alertController, animated: true)
    }
}

extension CommentsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentCell = tableView.dequeueReusableCell(for: indexPath)
        let comment = comments[indexPath.row]

        cell.avatarUrl = comment.user.profile?.profilePicture?.url
        cell.comment = comment.commentContent

        return cell
    }
}
