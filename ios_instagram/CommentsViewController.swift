//
//  CommentsViewController.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 26/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var picture: Picture!
    var comments = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTitle("COMMENTS")
        self.loadComments()
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // disable scrolling if no comments
        if self.comments.count + 1 == 0 {
            self.tableView.scrollEnabled = false
        } else {
            self.tableView.scrollEnabled = true
        }
        return self.comments.count + 1
    }
    
    func loadComments(){
        let pictureUid = self.picture.pictureKey
        let baseRef = DataServices.dataService
        let pictureRef = baseRef.PICTURE_REF.childByAppendingPath(pictureUid)
        let commentsRef = pictureRef.childByAppendingPath("comments")
        
        // event listener for all comments under picture
        commentsRef.observeEventType(.ChildAdded, withBlock: { commentInfo in
            let uid = commentInfo.key
            let ref = baseRef.COMMENT_REF.childByAppendingPath(uid)
            
            // get comment info
            ref.observeSingleEventOfType(.Value, withBlock: {snapshot in
                let commentDict = snapshot.value as! NSDictionary
                let userUid = commentDict["user_uid"] as! String
                let userRef = baseRef.USER_REF.childByAppendingPath(userUid)
                
                // get comment poster's info
                userRef.observeSingleEventOfType(.Value, withBlock: {userInfo in
                    let userDict = userInfo.value as! NSDictionary
                    let comment = Comment.init(key: uid, dict: commentDict, userDict: userDict)
                    self.comments.append(comment)
                    self.tableView.reloadData()
                })
            })
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CommentCell")!
        if indexPath.row == 0 {
            //load picture caption on first row
            cell.textLabel!.attributedText = self.picture.formattedDescription()
        } else {
            // load comments
            let comment = self.comments[indexPath.row-1]
            cell.textLabel!.attributedText = comment.formattedForTextView()
        }
        self.updateContentInsetForTableView(tableView, animated: false)
        return cell
    }

    func loadTitle(string: String)->Void{
        let lbNavTitle = UILabel()
        lbNavTitle.frame = CGRectMake(0,40,320,40)
        lbNavTitle.textAlignment = NSTextAlignment.Left
        lbNavTitle.text = string
        self.navigationItem.titleView = lbNavTitle;
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
    }
    
    func updateContentInsetForTableView(tableView: UITableView, animated: Bool) {
        let lastRow: Int = self.tableView(tableView, numberOfRowsInSection: 0)
        let lastIndex: Int = lastRow > 0 ? lastRow - 1 : 0
        let lastIndexPath: NSIndexPath = NSIndexPath(forItem: lastIndex, inSection: 0)
        let lastCellFrame: CGRect = self.tableView.rectForRowAtIndexPath(lastIndexPath)
        // top inset = table view height - top position of last cell - last cell height
        let topInset: CGFloat = max(CGRectGetHeight(self.tableView.frame) - lastCellFrame.origin.y - CGRectGetHeight(lastCellFrame), 0)
        var contentInset: UIEdgeInsets = tableView.contentInset
        contentInset.top = topInset
        let options: UIViewAnimationOptions = .BeginFromCurrentState
        UIView.animateWithDuration(animated ? 0.25 : 0.0, delay: 0.0, options: options, animations: {() -> Void in
            tableView.contentInset = contentInset
            }, completion: {(finished: Bool) -> Void in
        })
    }
}
