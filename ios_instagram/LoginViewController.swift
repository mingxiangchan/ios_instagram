//
//  ViewController.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 22/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var passwordtextField: UITextField!
    var gradient: CAGradientLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.lightGrayColor()
    }
    
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.adjustLoginButton(0.2)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Sets the translucent background color
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        self.navigationController?.navigationBar.translucent = true
        self.gradient = CAGradientLayer()
        self.gradient.frame = self.view.bounds
        self.gradient.startPoint = CGPointZero;
        self.gradient.endPoint = CGPointMake(1, 1);
        self.gradient.colors =
            LOGIN_COLORS
        self.view.layer.insertSublayer(self.gradient, atIndex: 0)
        self.animateLayer(self.randomColor().CGColor, bottomColor: self.randomColor().CGColor)
    }
    
    func adjustLoginButton(alpha: CGFloat){
        self.loginButton.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
        self.loginButton.layer.borderWidth = 2
        self.loginButton.layer.cornerRadius = 5
        self.loginButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(alpha), forState: .Normal)
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
        CATransaction.setCompletionBlock({ self.animateLayer(self.randomColor().CGColor, bottomColor: self.randomColor().CGColor)})
        self.gradient.addAnimation(animation, forKey: "animateGradient")
        CATransaction.commit()
        
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
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(self.emailTextField.text != "" && self.passwordtextField.text != ""){
            self.adjustLoginButton(1)
        }
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
}

//let currentUserId = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
//if currentUserId != nil {
//    if DataService.dataservice.USER_REF.childByAppendingPath(currentUserId)!.authData != nil{
//        self.performSegueWithIdentifier("LoggedIn", sender: nil)
//    }
//}