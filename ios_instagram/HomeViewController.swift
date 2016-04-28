//
//  HomeViewController.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 22/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PictureTableViewCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTitle("FEED")
        self.tableView.estimatedRowHeight = 30
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.loadFeed()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.pictures.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let picture = self.pictures[section]
        let username = picture.user!["username"] as! String
        return username
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("PictureCell")! as! PictureTableViewCell
        let picture = self.pictures[indexPath.section]
        cell.initializeContents(picture)
        cell.delegate = self
        return cell
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}
    
    func loadFeed() -> Void{
        // load own pictures
        let uid = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
        self.loadPictures(uid!)
        // load follower ppl pictures
    }
    
    func loadPictures(uid: String){
        let userRef = DataServices.dataService.USER_REF.childByAppendingPath(uid)
        let userPictures = userRef.childByAppendingPath("pictures")
        userPictures.queryLimitedToLast(10).observeEventType(.ChildAdded, withBlock: { snapshot in
            if snapshot.value != nil {
                let pictureRef = DataServices.dataService.PICTURE_REF.childByAppendingPath(snapshot.key)
                pictureRef.observeSingleEventOfType(.Value, withBlock: { pictureInfo in
                    let picture_dict = pictureInfo.value as! NSDictionary
                    userRef.observeSingleEventOfType(.Value, withBlock: {userInfo in
                        let userDict = userInfo.value as! NSDictionary
                        
                        let picture = Picture.init(key: pictureInfo.key, dict: picture_dict, userDict: userDict)
                        self.pictures.append(picture)
                        self.addPictureChangesListener(picture)
                        self.tableView.reloadData()
                    })
                })
            }
        })
    }
    
    func addPictureChangesListener(picture: Picture){
        let ref = DataServices.dataService.PICTURE_REF.childByAppendingPath(picture.pictureKey)
        ref.observeEventType(.Value, withBlock: {snapshot in
            let pictureDict = snapshot.value as! NSDictionary
            picture.updateFromDict(pictureDict)
            self.tableView.reloadData()
        })
    }
    
    func onCommentsButtonPressed(sender: PictureTableViewCell) {
        let sectionIndex = self.tableView.indexPathForCell(sender)!.section
        let picture = self.pictures[sectionIndex]
        self.performSegueWithIdentifier("toCommentsSegue", sender: picture)
    }
    
    func onLikeButtonPressed(sender: PictureTableViewCell) {
        let sectionIndex = self.tableView.indexPathForCell(sender)!.section
        let picture = self.pictures[sectionIndex]
        picture.checkIfCurrentUserLiked({checkResult in
            if checkResult{
                picture.removeLike()
            } else {
                picture.addLike()
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toCommentsSegue" {
            let destination = segue.destinationViewController as! CommentsViewController
            if let picture = sender as? Picture {
                destination.picture = picture
            }
        }
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
}
