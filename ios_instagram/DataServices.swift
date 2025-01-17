//
//  DataServices.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 22/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import Foundation
import Firebase

class DataServices {
    static let dataService = DataServices()
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    private var _PICTURE_REF = Firebase(url: "\(BASE_URL)/pictures")
    private var _COMMENT_REF = Firebase(url: "\(BASE_URL)/comments")
    
    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    var USER_REF: Firebase {
        return _USER_REF
    }
    
    var PICTURE_REF: Firebase {
        return _PICTURE_REF
    }
    
    var COMMENT_REF: Firebase {
        return _COMMENT_REF
    }

    var CURRENT_USER_REF: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        
        return currentUser!
    }
    
    func pictureLikesRef(pictureUid: String) -> Firebase{
        return self.PICTURE_REF.childByAppendingPath(pictureUid).childByAppendingPath("users_who_liked")
    }
    
    func userLikesRef(userUid: String) -> Firebase{
        return self.CURRENT_USER_REF.childByAppendingPath("liked_pictures")
    }
}