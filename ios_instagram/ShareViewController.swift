//
//  ShareViewController.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 25/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit
import Firebase

class ShareViewController: UIViewController {
    var image: UIImage?
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var captionTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTitle("SHARE TO FOLLOWERS")
        self.loadBackButton()
        self.imageView.image = self.image
    }

    @IBAction func onDoneButtonPressed(sender: AnyObject) {
        let image = self.image
        let imageString = ImageResizer().encodeToString(image!, maxFileSizeinKB: 500)
        let caption = self.captionTextField.text!
        let pictDict = ["image_data": imageString,
                        "caption": caption]
        
        // add image to pictures
        let ref = DataServices.dataService
        let picRef = ref.BASE_REF.childByAppendingPath("pictures").childByAutoId()
        picRef.setValue(pictDict)
        let createdAt = FirebaseServerValue.timestamp()
        picRef.childByAppendingPath("created_at").setValue(createdAt)
        
        // add image to belong to current_user
        let currentUserID = Cookies.currentUserUid()
        let userRef = ref.USER_REF.childByAppendingPath(currentUserID)
        userRef.childByAppendingPath("pictures").updateChildValues([picRef.key:"true"])
        self.performSegueWithIdentifier("unwindToHomeSegue", sender: self)
        
        // add image to all user's follower's feeds
        let followersRef = userRef.childByAppendingPath("followers")
        followersRef.observeEventType(.Value, withBlock: {followersInfo in
            let followers = followersInfo.value as! NSDictionary
            for (followerId, _) in followers {
                let followerRef = ref.USER_REF.childByAppendingPath(followerId as! String)
                followerRef.childByAppendingPath("feed").updateChildValues([picRef.key: createdAt])
            }
        })
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

}
