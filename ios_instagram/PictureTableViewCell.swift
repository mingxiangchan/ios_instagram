//
//  PictureTableViewCell.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 25/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class PictureTableViewCell: UITableViewCell {
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    weak var delegate:PictureTableViewCellDelegate?
    
    func initializeContents(picture: Picture){
        // set image
        let resizedImage = ImageResizer().resize(picture.image, targetWidth: self.bounds.width)
        self.setImageView(resizedImage)
        
        // set caption
        if picture.caption == nil || picture.caption == "" {
            self.hideCaption()
        } else {
            self.setCaption(picture.formattedDescription())
        }
        
        // set likes lable
        self.setLabelLikes(picture.numLikes)
        
        // set like button
        picture.checkIfCurrentUserLiked({checkResult in
            if checkResult{
                self.likeButton.setImage(UIImage(named: "heart_red"), forState: UIControlState.Normal)
            } else {
                self.likeButton.setImage(UIImage(named: "heart"), forState: UIControlState.Normal)
            }
        })
    }
    
    func setImageView(image: UIImage) -> Void{
        self.mainImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        self.mainImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.mainImageView.image = image
        //self.mainImageView.heightAnchor.constraintEqualToConstant(image.size.height)
    }
    
    @IBAction func onCommentsButtonPressed(sender: AnyObject) {
        self.delegate?.onCommentsButtonPressed(self)
    }
    
    func setCaption(caption: NSAttributedString)-> Void{
        self.captionLabel.hidden = false
        self.captionLabel.attributedText = caption
    }
    
    func hideCaption(){
        // not working
        self.captionLabel.hidden = true
        self.captionLabel.heightAnchor.constraintEqualToConstant(0)
    }
    
    func setLabelLikes(numLikes: Int){
        self.likesLabel.text = "\(numLikes) likes"
    }
    
    @IBAction func onLikeButtonPressed(sender: UIButton) {
        self.toggleLikeButton()
        self.delegate?.onLikeButtonPressed(self)
    }
    
    func toggleLikeButton(){
        
        let currentButtonImage = self.likeButton.imageView!.image!
        let unTappedButtonImage = UIImage(named: "heart")
        let TappedButtonImage = UIImage(named: "heart_red")
        
        if currentButtonImage.isEqual(unTappedButtonImage) {
            self.likeButton.setImage(TappedButtonImage, forState: UIControlState.Normal)
        } else if currentButtonImage.isEqual(TappedButtonImage){
            self.likeButton.setImage(TappedButtonImage, forState: UIControlState.Normal)
        }
    }
}

protocol PictureTableViewCellDelegate: class {
    func onCommentsButtonPressed(sender: PictureTableViewCell)
    func onLikeButtonPressed(sender: PictureTableViewCell)
}