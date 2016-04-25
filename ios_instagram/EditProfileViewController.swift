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
        navigationItem.title = "Edit Profile"
        //  navigationItem.backBarButtonItem?.action=

    
    
    }
//    override func viewWillDisappear(animated: Bool) {
//    super.viewWillDisappear(true)
//        print("Iam in view dissapear")
//        if self.navigationController!.viewControllers.indexOf(self)==NSNotFound{
//            
//            
//            if let newBio = editBioTextLabel.text{
//                            if let currentUID=NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String {
//                
//                                DataServices.dataService.USER_REF.childByAppendingPath(currentUID).childByAppendingPath("bio").setValue(newBio)
//                            print("Iam in bio")}
//                        }
//                        if let newUsername = editUsernameTextLabel.text{
//                            let uuname = ["username": newUsername]
//                            if let currentID=NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String {
//                                DataServices.dataService.USER_REF.childByAppendingPath(currentID).updateChildValues(uuname)
//                           print("I am in username") }
//                        
//                    }
//
//            
//        }
//    }

// if let update chile values "username": newusername
    
//    var hopperRef = usersRef.childByAppendingPath("gracehop")
//    var nickname = ["nickname": "Amazing Grace"]
//    
//    hopperRef.updateChildValues(nickname)
    
//    -(void) viewWillDisappear:(BOOL)animated {
//    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
//    // Navigation button was pressed. Do some stuff
//    [self.navigationController popViewControllerAnimated:NO];
//    }
//    [super viewWillDisappear:animated];
//    }
    
    
    
//    func performEdit(sender) -> Void {
//        <#function body#>
//    }
//    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
//        
//        if let newBio = editBioTextLabel.text{
//            if let currentUID=NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String {
//                
//                DataServices.dataService.USER_REF.childByAppendingPath(currentUID).childByAppendingPath("bio").setValue(newBio)
//            }
//        }
//        if let newUsername = editUsernameTextLabel.text{
//            if let currentID=NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String {
//                DataServices.dataService.USER_REF.childByAppendingPath(currentID).childByAppendingPath("username").setValue(newUsername)
//            }
//        
//    }
//}
    
    @IBAction func onDonneButtonPressed(sender: UIButton) {
        if let newBio = editBioTextLabel.text{
            if let currentUID=NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String {
                
                DataServices.dataService.USER_REF.childByAppendingPath(currentUID).childByAppendingPath("bio").setValue(newBio)
                print("Iam in bio")}
        }
        if let newUsername = editUsernameTextLabel.text{
            let uuname = ["username": newUsername]
            if let currentID=NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String {
                DataServices.dataService.USER_REF.childByAppendingPath(currentID).updateChildValues(uuname)
                print("I am in username") }
            
        }
        
        
    }
}

