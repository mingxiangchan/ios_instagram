//
//  MyProfileViewController.swift
//  ios_instagram
//
//  Created by Abdo Assem on 4/23/16.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    var pictures = [Picture]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile"
        self.collectionView.backgroundColor = UIColor.clearColor()
        DataServices.dataService.CURRENT_USER_REF.childByAppendingPath("username").observeSingleEventOfType(.Value, withBlock:{ snapshot -> Void in
            if let username=snapshot.value as? String{
                self.userNameLabel.text=username
            }
        })
        self.loadImages()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pictures.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PictureCell", forIndexPath: indexPath)
        let picture = self.pictures[indexPath.row]
        let imageView = UIImageView()
        let imageWidth = (self.collectionView.frame.size.width - 40)/4
        imageView.frame = CGRectMake(0, 0, imageWidth, imageWidth)
        imageView.image = picture.image
        cell.addSubview(imageView)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // set size for collectionviewcell to 1/4th of page with 10 line spacing
        let imageWidth = (self.collectionView.frame.size.width - 40)/4
        return CGSizeMake(imageWidth, imageWidth)
    }
    
    func loadImages()-> Void{
        let ref = DataServices.dataService.CURRENT_USER_REF.childByAppendingPath("pictures")
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

}
