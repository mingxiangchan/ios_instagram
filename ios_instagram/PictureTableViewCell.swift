//
//  PictureTableViewCell.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 25/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class PictureTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    weak var delegate:PictureTableViewCellDelegate?
    
    func setImageView(image: UIImage) -> Void{
        self.mainImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        self.mainImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.mainImageView.image = image
        //self.mainImageView.heightAnchor.constraintEqualToConstant(image.size.height)
    }
    
    @IBAction func onCommentsButtonPressed(sender: AnyObject) {
        self.delegate?.onCommentsButtonPressed(self)
    }
    
    func setCaption(caption: String)-> Void{
        self.captionLabel.hidden = false
        self.captionLabel.text = caption
    }
    
    func hideCaption(){
        // not working
        self.captionLabel.hidden = true
        self.captionLabel.heightAnchor.constraintEqualToConstant(0)
    }
}

protocol PictureTableViewCellDelegate: class {
    func onCommentsButtonPressed(sender: PictureTableViewCell)
}