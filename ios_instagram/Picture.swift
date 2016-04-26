//
//  Post.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 25/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import Foundation
import UIKit

class Picture {
    var image: UIImage!
    var user: NSDictionary?
    var caption: String?
    private let _pictureKey: String!
    
    init(key: String, dict: NSDictionary, userDict: NSDictionary){
        self._pictureKey = key
        let imageString = dict["image_data"] as? String
        let image_data = NSData(base64EncodedString: imageString!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let image = UIImage(data: image_data!)
        
        self.image = image
        self.user = userDict
        
        if let imageCaption = dict["caption"] as? String{
            self.caption = imageCaption
        }
    }
}