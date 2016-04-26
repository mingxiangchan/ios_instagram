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
    
    func setImageView(image: UIImage) -> Void{
        self.mainImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        self.mainImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.mainImageView.image = image
//        self.mainImageView.heightAnchor.constraintEqualToConstant(image.size.height)
    }
    
    func setCaption(caption: String)-> Void{
        self.captionLabel.text = caption
        self.captionLabel.numberOfLines = 0
    }
}
