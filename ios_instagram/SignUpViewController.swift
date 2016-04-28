//
//  SignUpViewController.swift
//  ios_instagram
//
//  Created by Abdo Assem on 4/22/16.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var paswordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!

    @IBAction func onSignUpButtonPressed(sender: UIButton) {
        
        if let email = emailTextField.text, password = paswordTextField.text, username = nameTextField.text
        {
            DataServices.dataService.BASE_REF.createUser(email, password: password, withValueCompletionBlock: {
                (error,result) -> Void in
                if (error == nil)
                {
                    let uid = result ["uid"]as? String
 
                    let userDict = ["email":email, "username":username] //add photos , followers
                    
                   
                    let currentUser = DataServices.dataService.BASE_REF.childByAppendingPath("users").childByAppendingPath(uid)
                    currentUser.setValue(userDict)

                    NSUserDefaults.standardUserDefaults().setValue(uid, forKey: "uid")
                    
                    let appDelegateTemp = UIApplication.sharedApplication().delegate
                    
                    appDelegateTemp!.window!!.rootViewController = UIStoryboard.init(name: "TabRouting", bundle: NSBundle.mainBundle()).instantiateInitialViewController()
                }
                else{
                    let alert = UIAlertController(title: "Opps !", message: "Your email is taken or invalid", preferredStyle: .Alert)
                    let useraction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(useraction)
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    print(error)
                }
            })
        }
        
    }
}
