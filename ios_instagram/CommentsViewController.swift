//
//  CommentsViewController.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 26/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit
import Firebase

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var newCommentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var picture: Picture!
    var comments = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTitle("COMMENTS")
        self.loadComments()
        self.loadBackButton()
        // Do any additionawl setup after loading the view.
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
            for view in cell.contentView.subviews{
                if view.isMemberOfClass(UIView){
                    view.layer.zPosition = 1
                }
            }
        } else {
            // load comments
            let comment = self.comments[indexPath.row-1]
            cell.textLabel!.attributedText = comment.formattedForTextView()
            for view in cell.contentView.subviews{
                if view.isMemberOfClass(UIView){
                    view.hidden = true
                }
            }
        }
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.updateContentInsetForTableView(tableView, animated: false)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 80.0
        }
        return 40
    }
    


    func loadTitle(string: String)->Void{
        let lbNavTitle = UILabel()
        lbNavTitle.frame = CGRectMake(-20,40,320,40)
        lbNavTitle.textAlignment = NSTextAlignment.Left
        let attributes = [NSFontAttributeName: UIFont.init(name: "HelveticaNeue-Bold" , size: 18)!]
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        lbNavTitle.textColor = UIColor.whiteColor()
        lbNavTitle.attributedText = attributedString
        self.navigationItem.titleView = lbNavTitle;
        self.navigationController?.navigationBar.barTintColor = PRIMARY_BLUE_COLOR
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func loadBackButton(){
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
    
    @IBAction func onPostButtonPressed(sender: AnyObject) {
        let input = self.newCommentTextField.text!
        let userUid = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let pictureUid = self.picture.pictureKey
        let ref = DataServices.dataService
        
        // upload comment
        let commentRef = ref.COMMENT_REF.childByAutoId()
        let commentDict = ["body": input,
                           "user_uid": userUid,
                           "picture_uid": pictureUid]
        commentRef.setValue(commentDict)
        commentRef.childByAppendingPath("created_at").setValue(FirebaseServerValue.timestamp())
        
        // add comment under user
        let userCommentRef = ref.CURRENT_USER_REF.childByAppendingPath("comments")
        userCommentRef.updateChildValues([commentRef.key: "true"])
        
        // add comment under picture
        let pictureCommentRef = ref.PICTURE_REF.childByAppendingPath(pictureUid).childByAppendingPath("comments")
        pictureCommentRef.updateChildValues([commentRef.key: "true"])

        self.newCommentTextField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
