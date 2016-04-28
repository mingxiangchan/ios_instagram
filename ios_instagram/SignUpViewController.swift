//
//  SignUpViewController.swift
//  ios_instagram
//
//  Created by Abdo Assem on 4/22/16.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var signupButton: UIButton!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var paswordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    var gradient: CAGradientLayer!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.adjustSignUpButton(0.2)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Sets the translucent background color
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        self.navigationController?.navigationBar.translucent = true
        self.gradient = CAGradientLayer()
        self.gradient.frame = self.view.bounds
        self.gradient.colors =
            [UIColor.purpleColor().CGColor, UIColor.blueColor().CGColor]
        self.view.layer.insertSublayer(self.gradient, atIndex: 0)
        self.animateLayer(UIColor.purpleColor().CGColor, bottomColor: UIColor.blueColor().CGColor)
    }
    
    func adjustSignUpButton(alpha: CGFloat){
        self.signupButton.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
        self.signupButton.layer.borderWidth = 2
        self.signupButton.layer.cornerRadius = 5
        self.signupButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(alpha), forState: .Normal)
    }
    
    func animateLayer(topColor: CGColor, bottomColor: CGColor){
        CATransaction.begin()
        let fromColors = self.gradient.colors;
        let toColors = [bottomColor, topColor]
        self.gradient.colors = toColors
        let animation = CABasicAnimation.init(keyPath: "colors")
        animation.fromValue             = fromColors;
        animation.toValue               = toColors;
        animation.duration              = 5.00;
        animation.removedOnCompletion   = true;
        animation.fillMode              = kCAFillModeForwards;
        animation.timingFunction        = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        animation.delegate              = self;
        CATransaction.setCompletionBlock({ self.animateLayer(bottomColor, bottomColor: topColor)})
        self.gradient.addAnimation(animation, forKey: "animateGradient")
        CATransaction.commit()
        
    }
    
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
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(self.emailTextField.text != "" && self.paswordTextField.text != "" && self.nameTextField.text != ""){
            self.adjustSignUpButton(1)
        }
    }
}
