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
    
    init(key: String, dict: NSDictionary, userDict: NSDictionary?=nil){
        self._pictureKey = key
        let imageString = dict["image_data"] as? String
        let image = self.decodeImage(imageString!)
        
        self.image = image
        self.user = userDict
        
        if let imageCaption = dict["caption"] as? String{
            self.caption = imageCaption
        }
    }
    
    func decodeImage(imageString: String) -> UIImage {
        let image_data = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        return UIImage(data: image_data!)!
    }
    
    var pictureKey: String {
        return _pictureKey
    }
    
    func formattedDescription() -> NSAttributedString{
        let result = NSMutableAttributedString()
        result.insertAttributedString(self.formattedUsername(), atIndex: 0)
        if self.caption != nil {
            let lastCharIndex = result.length
            result.insertAttributedString(self.formattedCaption(), atIndex: lastCharIndex)
        }
        return NSAttributedString.init(attributedString: result)
    }
    
    func formattedUsername() -> NSAttributedString {
        // highlight username and add link
        // pending fix for userUid
        // let userUidAttr = ["NSLinkAttributeName", "userUid"]
        let username = self.user!["username"] as! String + ": "
        let fontAttrs = [NSFontAttributeName: UIFont.boldSystemFontOfSize(15.0),
                         NSForegroundColorAttributeName: UIColor.blueColor()]
        let attributedUsername = NSAttributedString(string: username, attributes: fontAttrs)
        return attributedUsername
    }
    
    func formattedCaption() -> NSAttributedString {
        let bodyFontAttr = [NSFontAttributeName: UIFont.systemFontOfSize(15.0)]
        let attributedBody = NSAttributedString(string: self.caption!, attributes: bodyFontAttr)
        return attributedBody
    }
    
    func addLike(){
        let ref = DataServices.dataService
        
        // get required uids
        let likeRef = ref.LIKE_REF.childByAutoId()
        let likeUid = likeRef.key
        let userUid = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let pictureUid = self.pictureKey
        
        // add like under likes table
        let likeDict = ["picture_uid": pictureUid, "user_uid": userUid]
        likeRef.setValue(likeDict)
        
        // add like uid under pictures table
        let pictureLikesRef = ref.PICTURE_REF.childByAppendingPath(pictureUid).childByAppendingPath("likes")
        pictureLikesRef.updateChildValues([likeUid: "true"])
        
        // add like uid under users table
        let userLikesRef = ref.CURRENT_USER_REF.childByAppendingPath("likes")
        userLikesRef.updateChildValues([likeUid: "true"])
        
        likeRef.observeSingleEventOfType(.Value, withBlock: {snapshot in print(snapshot)})
        pictureLikesRef.observeSingleEventOfType(.Value, withBlock: {snapshot in print(snapshot)})
        userLikesRef.observeSingleEventOfType(.Value, withBlock: {snapshot in print(snapshot)})
    }
}