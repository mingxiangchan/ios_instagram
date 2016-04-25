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
    
    func setImageView(image: UIImage) -> Void{
        self.mainImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        self.mainImageView.image = image
    }
}
