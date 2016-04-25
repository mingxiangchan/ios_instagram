//
//  ShareViewController.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 25/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    var image: UIImage?
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var captionTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTitle("SHARE TO FOLLOWERS")
        self.imageView.image = self.image
    }

    @IBAction func onDoneButtonPressed(sender: AnyObject) {
        let image = self.image
        let imageString = ImageResizer().encodeToString(image!, maxFileSizeinKB: 500)
        let caption = self.captionTextField.text!
        let pictDict = ["image_data": imageString,
                        "caption": caption]
        
        // add image to pictures
        let ref = DataServices.dataService
        let picRef = ref.BASE_REF.childByAppendingPath("pictures").childByAutoId()
        picRef.setValue(pictDict)
        
        // add image to belong to current_user
        let currentUserID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
        let userRef = ref.USER_REF.childByAppendingPath(currentUserID)
        userRef.childByAppendingPath("pictures").updateChildValues([picRef.key:"true"])
        self.performSegueWithIdentifier("unwindToHomeSegue", sender: self)
    }
    
    func loadTitle(string: String)->Void{
        let lbNavTitle = UILabel()
        lbNavTitle.frame = CGRectMake(0,40,320,40)
        lbNavTitle.textAlignment = NSTextAlignment.Left
        lbNavTitle.text = string
        self.navigationItem.titleView = lbNavTitle;
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
    }

}
