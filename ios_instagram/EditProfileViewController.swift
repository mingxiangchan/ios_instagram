//
//  EditProfileViewController.swift
//  ios_instagram
//
//  Created by Abdo Assem on 4/24/16.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {


    @IBOutlet weak var editUsernameTextLabel: UITextField!
    @IBOutlet weak var editBioTextLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTitle("EDIT PROFILE")
        self.loadBackButton()
        self.loadPersonalInfo()
    }
    
    @IBAction func onDoneButtonPressed(sender: AnyObject) {
        let ref = DataServices.dataService.CURRENT_USER_REF
        let userDict = ["username": self.editUsernameTextLabel.text!,
                        "bio": self.editBioTextLabel.text!]
        ref.updateChildValues(userDict)
        self.performSegueWithIdentifier("unwindToMyProfileSegue", sender: self)
    }
    
    func loadPersonalInfo() -> Void{
        DataServices.dataService.CURRENT_USER_REF.observeEventType(.Value, withBlock:{ snapshot -> Void in
            if let username=snapshot.value["username"] as? String{
                self.editUsernameTextLabel.text=username
            }
            if let bio = snapshot.value["bio"] as? String{
                self.editBioTextLabel.text = bio
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

