//
//  OptionsViewController.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 27/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTitle("OPTIONS")
        // Do any additional setup after loading the view.
    }
    @IBAction func onEditProfileButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindToMyProfileSegue", sender: self)
    }

    @IBAction func onLogOutButtonPressed(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("uid")
        let appDelegateTemp = UIApplication.sharedApplication().delegate
        let rootController: UIViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("LoginViewController")
        let navigation: UINavigationController = UINavigationController(rootViewController: rootController)
        appDelegateTemp!.window!!.rootViewController = navigation

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
}
