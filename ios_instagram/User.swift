//
//  User.swift
//
//
//  Created by Abdo Assem on 4/22/16.
//
//

import Foundation
class User{
    private let _userkey: String!
    var username: String!
    var email :String!
    var bio :String!
    var userkey:String!{
        return _userkey
    }
    
    init (key: String, dict: [String : AnyObject]){
        self._userkey=key
        if let username = dict ["username"] as? String{
            self.username = username
        }else{
            self.username = "UserNamefound"
        }
        
            if let email = dict["email"] as? String{
            self.email=email
        }else{
            self.email = "email@notfound.com"
        }
        if let bio = dict ["bio"] as? String{
            self.bio=bio
        }else{
            self.bio = "BioNotfound"
        }
    }
    
    func checkIfFollowingThisUser(completionHandler: (checkResult: Bool)->Void) -> Void {
        let ref = DataServices.dataService
        let targetRef = ref.CURRENT_USER_REF.childByAppendingPath("following").childByAppendingPath(self.userkey)
        
        targetRef.observeSingleEventOfType(.Value, withBlock: {snapshot in
            let result = snapshot.value.isEqual(NSNull())
            completionHandler(checkResult: !result)
        })
    }
    
    func followThisUser(){
        // add selected user as following for current user
        let currentUserUid = Cookies.currentUserUid()
        let ref = DataServices.dataService.CURRENT_USER_REF.childByAppendingPath("following")
        ref.updateChildValues([self.userkey: "true"])
        
        // add current user as follower for selected user
        let followerRef = DataServices.dataService.USER_REF.childByAppendingPath(self.userkey).childByAppendingPath("followers")
        followerRef.updateChildValues([currentUserUid: "true"])
    }
    
    func unFollowThisUser(){
        // remove selected user as following for current user
        let currentUserUid = Cookies.currentUserUid()
        let ref = DataServices.dataService.CURRENT_USER_REF.childByAppendingPath("following")
        ref.childByAppendingPath(self.userkey).removeValue()
        
        // remove current user as follower for selected user
        let followerRef = DataServices.dataService.USER_REF.childByAppendingPath(self.userkey).childByAppendingPath("followers")
        followerRef.childByAppendingPath(currentUserUid).removeValue()
    }
}



