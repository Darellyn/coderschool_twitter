//
//  TwitterClient.swift
//  Twitter
//
//  Created by Hieu Rocker on 3/25/16.
//  Copyright © 2016 Hieu Rocker. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "MSUgw3aTgRNIUjxyh4VXZnYQ4", consumerSecret: "XHWxSnr9ucXL6QAeH8vGnMrrHqjLaAqeguuFy3tmbt3hXeYCiF")

    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func homeTimeLine(sinceId: String?, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        var parameters = [String: AnyObject]()
        if let sinceId = sinceId {
            parameters["since_id"] = sinceId
        }
        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: parameters, progress: nil, success: { (_, response: AnyObject?) in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                success(tweets)
            }) { (_, error: NSError) in
                failure(error)
            }
    }
    
    func currentAccount(success: User -> (), failure: NSError -> ()) {
        TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (_: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                success(user)
            }) { (_: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
            }
    }
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure

        deauthorize()
        fetchRequestTokenWithPath("https://api.twitter.com/oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                self.openTwitterLoginPage(requestToken.token)
            }) { (error: NSError!) -> Void in
                self.loginFailure?(error)
                self.loginFailure = nil
            }
    }
    
    func openTwitterLoginPage(token: String!) {
        let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("https://api.twitter.com/oauth/access_token", method: "POST", requestToken: requestToken, success: { _ -> Void in
            self.currentAccount({ (user) in
                User.currentUser = user
                self.loginSuccess?()
                self.loginSuccess = nil
            }, failure: { (error) in
                self.loginFailure?(error)
                self.loginFailure = nil
            })
        }) { (error: NSError!) -> Void in
            self.loginFailure?(error)
            self.loginFailure = nil
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogOutNotification, object: nil)
    }
    
    func postStatus(replyToTweet: Tweet?, status: String, success: (Tweet -> ())?, failure: (NSError -> ())?) {
        var parameters = [String: AnyObject]()
        parameters["status"] = status
        if let replyToTweet = replyToTweet {
            parameters["in_reply_to_status_id"] = "\(replyToTweet.id!)"
            if let photo = replyToTweet.photo {
                parameters["media_ids"] = "\(photo.id!)"
            }
        }
        TwitterClient.sharedInstance.POST("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (_, response: AnyObject?) in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            success?(tweet)
        }) { (_, error: NSError) in
            failure?(error)
        }
    }
    
    func retweet(tweet: Tweet, success: (Tweet -> ())?, failure: (NSError -> ())?) {
        let retweet = tweet.retweetedStatus ?? tweet
        TwitterClient.sharedInstance.POST("1.1/statuses/retweet/\(retweet.id!).json", parameters: nil, progress: nil, success: { (_, response: AnyObject?) in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            success?(tweet)
        }) { (_, error: NSError) in
            failure?(error)
        }
    }

    func unretweet(tweet: Tweet, success: (Tweet -> ())?, failure: (NSError -> ())?) {
        TwitterClient.sharedInstance.POST("1.1/statuses/unretweet/\(tweet.id!).json", parameters: nil, progress: nil, success: { (_, response: AnyObject?) in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            success?(tweet)
        }) { (_, error: NSError) in
            failure?(error)
        }
    }
    
    func favorite(tweet: Tweet, favorited: Bool, success: (Tweet -> ())?, failure: (NSError -> ())?) {
        TwitterClient.sharedInstance.POST("1.1/favorites/\(favorited ? "create" : "destroy").json", parameters: ["id": "\(tweet.id!)"], progress: nil, success: { (_, response: AnyObject?) in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            success?(tweet)
        }) { (_, error: NSError) in
            failure?(error)
        }
    }
}
