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
     
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        navigationItem.title = "Profile"
        DataServices.dataService.CURRENT_USER_REF.childByAppendingPath("username").observeSingleEventOfType(.Value, withBlock:{ snapshot -> Void in
                if let username=snapshot.value as? String{
                    self.userNameLabel.text=username
                    
                }
        })
    }

}
