//
//  Cookies.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 27/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import Foundation

class Cookies{
    class func currentUserUid() -> String{
        return NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
    }
}