//
//  HomeViewController.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 22/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 100
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
        let username = picture.user["username"]
        return username
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("PictureCell")! as! PictureTableViewCell
        let picture = self.pictures[indexPath.section]
        let resizedImage = ImageResizer().resize(picture.image, targetWidth: cell.bounds.width)
        cell.setImageView(resizedImage)
        return cell
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}
    
    func loadFeed() -> Void{
        let firebase = DataServices.dataService
        let userPictures = firebase.CURRENT_USER_REF.childByAppendingPath("pictures")
        userPictures.observeEventType(.ChildAdded, withBlock: { snapshot in
            if snapshot.value != nil {
                let pictureRef = firebase.PICTURE_REF.childByAppendingPath(snapshot.key)
                pictureRef.observeSingleEventOfType(.Value, withBlock: { pictureInfo in
                    let picture_dict = pictureInfo.value as! NSDictionary
                    let picture = Picture.init(key: pictureInfo.key, dict: picture_dict)
                    self.pictures.append(picture)
                    self.tableView.reloadData()
                })
            }
        })
    }
}
