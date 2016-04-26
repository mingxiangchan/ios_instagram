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
}



