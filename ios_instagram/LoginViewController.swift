//
//  ViewController.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 22/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var passwordtextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.lightGrayColor()
    }

    
    @IBAction func onLoginButtonPressed(sender: UIButton) {
        if let email = emailTextField.text, password = passwordtextField.text{
            
            DataServices.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: {(error, authData) -> Void in
                if (error == nil){
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    self.notificationLabel.text = "You're logged in // DO SEGUE"
                    let appDelegateTemp = UIApplication.sharedApplication().delegate
                    
                    appDelegateTemp!.window!!.rootViewController = UIStoryboard.init(name: "TabRouting", bundle: NSBundle.mainBundle()).instantiateInitialViewController()
                }else{
                    print(error)
                    self.notificationLabel.text = "something's wrong"
                }
            })
            
        }
    }
    
    @IBAction func onSignUpButtonPressed(sender: UIButton) {
        
    }
}

//let currentUserId = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
//if currentUserId != nil {
//    if DataService.dataservice.USER_REF.childByAppendingPath(currentUserId)!.authData != nil{
//        self.performSegueWithIdentifier("LoggedIn", sender: nil)
//    }
//}