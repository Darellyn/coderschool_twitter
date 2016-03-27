//
//  TweetViewController.swift
//  Twitter
//
//  Created by Hieu Rocker on 3/27/16.
//  Copyright © 2016 Hieu Rocker. All rights reserved.
//

import UIKit
import FontAwesome_swift
import MBProgressHUD

@objc protocol TweetDelegate {
    optional func tweetDidFavorite(tweet: Tweet)
    optional func tweetDidUnFavorite(tweet: Tweet)
    optional func tweetDidRetweet(tweet: Tweet)
    optional func tweetDidUnRetweet(tweet: Tweet)
    optional func tweetDidPost(tweet: Tweet)
}

class TweetViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var retweetTypeView: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var retweetByView: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var screenNameView: UILabel!
    @IBOutlet weak var timeView: UILabel!
    @IBOutlet weak var statusView: UILabel!
    @IBOutlet weak var replyView: UIButton!
    @IBOutlet weak var retweetView: UIButton!
    @IBOutlet weak var retweetCountView: UILabel!
    @IBOutlet weak var starView: UIButton!
    @IBOutlet weak var starCountView: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarTopConstraint: NSLayoutConstraint!
    let iconSize = CGFloat(20)
    var tweet: Tweet?
    var tweetDidPost: Tweet?
    var delegate: TweetDelegate?
    
    override func viewDidLoad() {
        renderTweet()
    }
    
    @IBAction func onReplyClicked(sender: UIButton) {
        self.performSegueWithIdentifier("replyTweetSegue", sender: nil)
    }
    
    @IBAction func onRetweetClicked(sender: UIButton) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let retweeted = !tweet!.retweeted
        TwitterClient.sharedInstance.retweet(tweet!, retweeted: retweeted, success: { (tweet) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tweet? = tweet
            self.renderTweet()
            if tweet.retweeted {
                self.delegate?.tweetDidRetweet?(tweet)
            } else {
                self.delegate?.tweetDidUnRetweet?(tweet)
            }
        }) { (error) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            ViewUtils.viewController(self, displayMessage: error.localizedDescription)
        }
    }
    
    @IBAction func onFavoriteClicked(sender: UIButton) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        TwitterClient.sharedInstance.favorite(tweet!, favorited: !(tweet?.favorited)! ?? true, success: { (tweet) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tweet = tweet
            self.renderTweet()
            if tweet.favorited {
                self.delegate?.tweetDidFavorite?(tweet)
            } else {
                self.delegate?.tweetDidUnFavorite?(tweet)
            }
        }) { (error) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            ViewUtils.viewController(self, displayMessage: error.localizedDescription)
        }
    }
    
    func renderTweet() {
        retweetTypeView.font = UIFont.fontAwesomeOfSize(self.iconSize)
        replyView.titleLabel?.font = UIFont.fontAwesomeOfSize(self.iconSize)
        retweetView.titleLabel?.font = UIFont.fontAwesomeOfSize(self.iconSize)
        starView.titleLabel?.font = UIFont.fontAwesomeOfSize(self.iconSize)
        
        retweetTypeView.text = String.fontAwesomeIconWithName(.Retweet)
        replyView.setTitle(String.fontAwesomeIconWithName(.Reply), forState: .Normal)
        retweetView.setTitle(String.fontAwesomeIconWithName(.Retweet), forState: .Normal)
        let retweeted = tweet?.retweeted ?? false
        retweetView.setTitleColor(retweeted ? TweetCell.highlightColor : UIColor.lightGrayColor(), forState: .Normal)
        let favorited = tweet?.favorited ?? false
        starView.setTitle(String.fontAwesomeIconWithName(favorited ? .Star : .StarO), forState: .Normal)
        starView.setTitleColor(favorited ? TweetCell.highlightColor : UIColor.lightGrayColor(), forState: .Normal)
        
        let retweetedStatus = tweet?.retweetedStatus
        if let retweetedStatus = retweetedStatus {
            retweetTypeView.hidden = false
            retweetByView.hidden = false
            retweetByView.text = "\(tweet?.user?.name ?? "") retweeted"
            avatarTopConstraint.constant = 37
            authorLabel.text = retweetedStatus.user?.name
            screenNameView.text = "@\(retweetedStatus.user?.screenName ?? "")"
        } else {
            retweetTypeView.hidden = true
            retweetByView.hidden = true
            avatarTopConstraint.constant = 8
            authorLabel.text = tweet?.user?.name
            screenNameView.text = "@\(tweet?.user?.screenName ?? "")"
        }
        statusView.text = tweet?.text ?? ""
        photoView.image = nil
        if let photoUrlLarge = tweet?.photo?.mediaLargeUrl {
            photoView.af_setImageWithURL(photoUrlLarge, imageTransition: .CrossDissolve(0.2))
            let ratio = tweet?.photo?.ratio
            if let ratio = ratio {
                photoViewHeightConstraint.constant = photoView.frame.width * ratio
            }
        } else {
            photoViewHeightConstraint.constant = 0
        }
        avatarImageView.image = nil
        if let profileUrl = tweet?.user?.profileUrl {
            avatarImageView.af_setImageWithURL(profileUrl, imageTransition: .CrossDissolve(0.2))
        }
        let retweetCount = tweet?.retweetCount ?? 0
        retweetCountView.text = "\(retweetCount)"
        let favoritesCount = tweet?.favoritesCount ?? 0
        starCountView.text = "\(favoritesCount)"
        timeView.text = tweet?.timestamp?.formattedDateWithStyle(NSDateFormatterStyle.LongStyle, timeZone: NSTimeZone.defaultTimeZone())
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: contentView.frame.size.height + 20)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "replyTweetSegue" {
            if let vc = segue.destinationViewController as? PostTweetViewController {
                vc.tweet = self.tweet
            }
        }
    }
}

extension TweetViewController: TweetDelegate {
    func tweetDidPost(tweet: Tweet) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.tweetDidPost?(tweet)
    }
}
