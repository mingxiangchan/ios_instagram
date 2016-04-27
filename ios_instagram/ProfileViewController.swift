//
//  MyProfileViewController.swift
//  ios_instagram
//
//  Created by Abdo Assem on 4/23/16.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pictures = [Picture]()
    var userUid : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = UIColor.clearColor()
        
        if self.userUid == nil {
            self.userUid = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        }
        self.loadPersonalInfo()
        self.loadImages()
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
        let ref = DataServices.dataService.USER_REF.childByAppendingPath(self.userUid)
        ref.observeEventType(.Value, withBlock:{ snapshot -> Void in
            if let username=snapshot.value["username"] as? String{
                self.userNameLabel.text=username
                self.loadTitle(username.uppercaseString)
            }
            if let bio = snapshot.value["bio"] as? String{
                self.bioTextView.text = bio
            }
        })
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
    
    @IBAction func unwindToMyProfile(segue: UIStoryboardSegue) {}

}
