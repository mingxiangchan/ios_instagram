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
        self._userkey=key
        if let username = dict ["username"] as? String{
            self.username = username
        }
    }
    
}

//DataService.dataService.TWEET_REF.observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
//    if let value = snapshot.value as? [String : AnyObject]{
//        let tweet = Tweet(key: snapshot.key, dict: value)
//        self.tweets.append(tweet)
//        self.tableView.reloadData()
//    }
//})


