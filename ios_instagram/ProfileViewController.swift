//
//  MyProfileViewController.swift
//  ios_instagram
//
//  Created by Abdo Assem on 4/23/16.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editFollowingButton: UIButton!
    
    var pictures = [Picture]()
    var userUid : String?
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.editFollowingButton.layer.cornerRadius = 10
        self.checkUser()
    }
    
    func checkIfLoggedInUser() -> Bool{
        return self.userUid! == Cookies.currentUserUid()
    }
    
    func checkUser(){
        if self.userUid == nil {
            self.userUid = Cookies.currentUserUid()
        }
        self.setUser()
    }
    
    func setUser(){
        let ref = DataServices.dataService.USER_REF.childByAppendingPath(self.userUid)
        ref.observeEventType(.Value, withBlock: {snapshot in
            let userDict = snapshot.value as! [String : AnyObject]
            let user = User.init(key: snapshot.key, dict: userDict)
            self.user = user
            self.loadPersonalInfo()
            if !self.checkIfLoggedInUser(){
                self.toggleFollowButton()
            }
        })
        self.loadImages()
    }
    
    @IBAction func onEditFollowingButtonPressed(sender: AnyObject) {
        if self.checkIfLoggedInUser(){
            self.performSegueWithIdentifier("editProfileSegue", sender: self)
        } else {
            self.user.checkIfFollowingThisUser({checkResult in
                if checkResult {
                    self.user.unFollowThisUser()
                } else {
                    self.user.followThisUser()
                }
                self.toggleFollowButton()
            })
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pictures.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PictureCell", forIndexPath: indexPath)
        let picture = self.pictures[indexPath.row]
        let imageView = UIImageView()
        let imageWidth = (self.collectionView.frame.size.width - 15)/3
        imageView.frame = CGRectMake(0, 0, imageWidth, imageWidth)
        imageView.image = picture.image
        cell.addSubview(imageView)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // set size for collectionviewcell to 1/4th of page with 10 line spacing
        let imageWidth = (self.collectionView.frame.size.width - 15)/3
        return CGSizeMake(imageWidth, imageWidth)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func loadPersonalInfo() -> Void{
        self.userNameLabel.text = self.user.username
        self.loadTitle(self.user.username.uppercaseString)
        self.bioTextView.text = self.user.bio
        self.postCountLabel.text = "\(self.user.postCount)"
        self.followerCountLabel.text = "\(self.user.followerCount)"
        self.followingCountLabel.text = "\(self.user.followingCount)"
    }
    
    func loadImages()-> Void{
        let ref = DataServices.dataService.USER_REF.childByAppendingPath(self.userUid).childByAppendingPath("pictures")
        ref.observeEventType(.ChildAdded, withBlock: { pictureIndex in
            let pictureRef = DataServices.dataService.PICTURE_REF.childByAppendingPath(pictureIndex.key)
            pictureRef.observeSingleEventOfType(.Value, withBlock: { pictureInfo in
                let pictureDict = pictureInfo.value as? NSDictionary
                let picture = Picture(key: pictureInfo.key, dict: pictureDict!)
                self.pictures.append(picture)
                self.collectionView.reloadData()
            })
        })
    
    }
    
    func loadTitle(string: String)->Void{
        let lbNavTitle = UILabel()
        lbNavTitle.frame = CGRectMake(0,40,320,40)
        lbNavTitle.textAlignment = NSTextAlignment.Left
        lbNavTitle.text = string
        self.navigationItem.titleView = lbNavTitle;
    }
    
    func toggleFollowButton(){
        self.editFollowingButton.layer.borderColor = UIColor.blueColor().CGColor
        self.editFollowingButton.layer.borderWidth = 2
        
        self.user.checkIfFollowingThisUser({checkResult in
            if checkResult{
                self.editFollowingButton.backgroundColor = UIColor.blueColor()
                self.editFollowingButton.setTitle("Following", forState: UIControlState.Normal)
                self.editFollowingButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            } else {
                self.editFollowingButton.backgroundColor = UIColor.clearColor()
                self.editFollowingButton.setTitle("Follow", forState: UIControlState.Normal)
                self.editFollowingButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            }
        })
    }
    
    @IBAction func unwindToMyProfile(segue: UIStoryboardSegue) {}

}
