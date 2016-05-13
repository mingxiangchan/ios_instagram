//
//  PhotoViewController.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 13/05/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var previewImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageViewController()
        // Do any additional setup after loading the view.
    }

    func setupImageViewController(){
        let ipc = UIImagePickerController()
        ipc.delegate = self
        ipc.sourceType = .Camera
        self.presentViewController(ipc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        previewImageView.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onNextButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("toShareControllerSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toShareControllerSegue" {
            let destination = segue.destinationViewController as! ShareViewController
            destination.image = previewImageView.image
        }
    }
    
}
