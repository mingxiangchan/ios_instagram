//
//  SearchDetailViewController.swift
//  ios_instagram
//
//  Created by Abdo Assem on 4/26/16.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class SearchDetailViewController: UIViewController {
    @IBOutlet weak var nameTextLabel: UILabel!
    var userProfile:User!
    
    @IBOutlet weak var bioTextLabel: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        self.title = userProfile.email;
        self.bioTextLabel.text=userProfile.bio
        self.nameTextLabel.text=userProfile.username
    }



    @IBAction func onFollowButtonPressed(sender: UIButton) {

        let userUid = self.userProfile.userkey
        let ref = DataServices.dataService.CURRENT_USER_REF.childByAppendingPath("following")
        ref.updateChildValues([userUid: "true"])
    }
    
}


