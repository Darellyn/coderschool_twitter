//
//  User.swift
//  Twitter
//
//  Created by Hieu Rocker on 3/25/16.
//  Copyright © 2016 Hieu Rocker. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileUrl: NSURL?
    var tagline: String?
    var dictionary: NSDictionary!
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenName = dictionary["name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        tagline = dictionary["description"] as? String
        self.dictionary = dictionary
    }
    static let userDidLogOutNotification = "UserDidLogout"
    private static let keyCurrentUserData = "currentUserData"
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey(keyCurrentUserData) as? NSData
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }

            }
            return _currentUser
        }
        set(user) {
            if _currentUser != user {
                _currentUser = user
                let defaults = NSUserDefaults.standardUserDefaults()
                if let user = user {
                    let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary, options: [])
                    defaults.setObject(data, forKey: keyCurrentUserData)
                } else {
                    defaults.removeObjectForKey(keyCurrentUserData)
                }
                defaults.synchronize()
            }
        }
    }
    
}
