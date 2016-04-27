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
    var numLikes: Int!
    private let _pictureKey: String!
    
    init(key: String, dict: NSDictionary, userDict: NSDictionary?=nil){
        self._pictureKey = key
        self.user = userDict
        self.updateFromDict(dict)
    }
    
    func updateFromDict(dict: NSDictionary){
        let imageString = dict["image_data"] as? String
        let image = self.decodeImage(imageString!)
        
        self.image = image
        let numLikes = dict["users_who_liked"]?.count!
        if numLikes == nil {
            self.numLikes = 0
        } else {
            self.numLikes = numLikes
        }
        
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
    
    func checkIfCurrentUserLiked(completionHandler: (checkResult: Bool)->Void) -> Void {
        let ref = DataServices.dataService
        let userUid = Cookies.currentUserUid()
        let pictureUid = self.pictureKey
        
        let targetRef = ref.pictureLikesRef(pictureUid).childByAppendingPath(userUid)
        
        targetRef.observeSingleEventOfType(.Value, withBlock: {snapshot in
            let result = snapshot.value.isEqual(NSNull())
            completionHandler(checkResult: !result)
        })
    }
    
    func addLike(){
        let ref = DataServices.dataService
        
        // get required uids
        let userUid = Cookies.currentUserUid()
        let pictureUid = self.pictureKey
        
        // add user uid under pictures table
        ref.pictureLikesRef(pictureUid).updateChildValues([userUid: "true"])
        
        // add picture uid under users table
        ref.userLikesRef(userUid).updateChildValues([pictureUid: "true"])
        
        ref.pictureLikesRef(pictureUid).observeSingleEventOfType(.Value, withBlock: {snapshot in print(snapshot)})
        ref.userLikesRef(userUid).observeSingleEventOfType(.Value, withBlock: {snapshot in print(snapshot)})
    }
    
    func removeLike(){
        let ref = DataServices.dataService
        
        // get required uids
        let userUid = Cookies.currentUserUid()
        let pictureUid = self.pictureKey
        
        // remove user uid under pictures table
        ref.pictureLikesRef(pictureUid).childByAppendingPath(userUid).removeValue()
        
        // remove picture uid under users table
        ref.userLikesRef(userUid).childByAppendingPath(pictureUid).removeValue()
        
        ref.pictureLikesRef(pictureUid).observeSingleEventOfType(.Value, withBlock: {snapshot in print(snapshot)})
        ref.userLikesRef(userUid).observeSingleEventOfType(.Value, withBlock: {snapshot in print(snapshot)})
    }
}