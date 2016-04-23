//
//  MyProfileViewController.swift
//  ios_instagram
//
//  Created by Abdo Assem on 4/23/16.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUserID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String {
                DataServices.dataService.USER_REF.childByAppendingPath("username").observeSingleEventOfType(.Value, withBlock:
                    {(snapshot) -> Void in
                        if let username=snapshot.value as? String{
                            self.userNameLabel.text=username
                            
                        }
            })
            
        }


    }



}
//@IBAction func OnTweetButtonPressed(sender: UIButton) {
//    if let text = tweetTextView.text{
//        if let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String{
//            DataService.dataService.CURRENT_USER_REF.childByAppendingPath("username").observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
//                if let username = snapshot.value as? String{
//                    let dict =  ["body" : text, "userID" : userID, "username" : username]
//                    //update tweet reference in database
//                    DataService.dataService.TWEET_REF.childByAutoId().setValue(dict, andPriority: nil, withCompletionBlock:  {(error, ref) -> Void in
//                        DataService.dataService.USER_REF.childByAppendingPath(userID).childByAppendingPath("tweets").updateChildValues([ref.key:true])
//                    })
//                }
//            })
//            
//            
//            
//        }
//    }
//}