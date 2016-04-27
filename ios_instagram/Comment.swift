//
//  Comment.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 26/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import Foundation
import UIKit

class Comment {
    var body: String!
    var user: NSDictionary!
    private let _commentKey: String!
    
    init(key: String, dict: NSDictionary, userDict: NSDictionary){
        self._commentKey = key
        self.body = dict["body"] as! String
        self.user = userDict
    }
    
    func formattedForTextView()-> NSAttributedString{
        let result = NSMutableAttributedString()
        result.insertAttributedString(self.formattedUsername(), atIndex: 0)
        let lastCharIndex = result.length
        result.insertAttributedString(self.formattedBody(), atIndex: lastCharIndex)
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
    
    func formattedBody() -> NSAttributedString {
        let bodyFontAttr = [NSFontAttributeName: UIFont.systemFontOfSize(15.0)]
        let attributedBody = NSAttributedString(string: self.body!, attributes: bodyFontAttr)
        return attributedBody
    }
}