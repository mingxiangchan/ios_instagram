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
    
    var userkey:String!{
        return _userkey
    }
    
    init (key: String, dict: [String : AnyObject]){
        self.-_userkey=key
        if let username = dict ["username"] as? String{
            self.usrname=username
        }
    }
}