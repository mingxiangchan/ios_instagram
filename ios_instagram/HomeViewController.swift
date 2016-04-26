//
//  HomeViewController.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 22/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let resizedImage = ImageResizer().resize(picture.image, targetWidth: cell.bounds.width)
        cell.setImageView(resizedImage)
        if picture.caption != nil {
            cell.setCaption(picture.caption!)
        }
        print("Picture Frame \(cell.mainImageView.frame)")
        print("Caption Frame \(cell.captionLabel.frame)")
        print("Cell Frame \(cell.frame)")
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
        userPictures.observeEventType(.ChildAdded, withBlock: { snapshot in
            if snapshot.value != nil {
                let pictureRef = DataServices.dataService.PICTURE_REF.childByAppendingPath(snapshot.key)
                pictureRef.observeSingleEventOfType(.Value, withBlock: { pictureInfo in
                    let picture_dict = pictureInfo.value as! NSDictionary
                    userRef.observeSingleEventOfType(.Value, withBlock: {userInfo in
                        let userDict = userInfo.value as! NSDictionary
                        
                        let picture = Picture.init(key: pictureInfo.key, dict: picture_dict, userDict: userDict)
                        self.pictures.append(picture)
                        self.tableView.reloadData()
                    })

                })
            }
        })
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        print("test")
        self.tableView.reloadData()
        return true
    }
    
}
