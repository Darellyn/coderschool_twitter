//
//  Tweet.swift
//  Twitter
//
//  Created by Hieu Rocker on 3/25/16.
//  Copyright © 2016 Hieu Rocker. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: Int64?
    var text: String?
    var timestamp: NSDate?
    var retweetCount = 0
    var favoritesCount = 0
    var user: User?
    var favorited = false
    var retweetedStatus: Tweet?
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? Int64
        text = dictionary["text"] as? String
        retweetCount = dictionary["retweet_count"] as? Int ?? 0
        favoritesCount = dictionary["favorite_count"] as? Int ?? 0
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
        let userData = dictionary["user"] as? NSDictionary
        if let userData = userData {
            user = User(dictionary: userData)
        }
        let retweetedStatusData = dictionary["retweeted_status"] as? NSDictionary
        if let retweetedStatusData = retweetedStatusData {
            retweetedStatus = Tweet(dictionary: retweetedStatusData)
        }
        favorited = dictionary["favorited"] as? Bool ?? false
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
