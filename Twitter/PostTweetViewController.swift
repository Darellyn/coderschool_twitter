//
//  PostTweetViewController.swift
//  Twitter
//
//  Created by Hieu Rocker on 3/27/16.
//  Copyright © 2016 Hieu Rocker. All rights reserved.
//

import UIKit
import MBProgressHUD

class PostTweetViewController: UIViewController {
    static let tweetPostedNotification = "tweetPosted"
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var screenNameView: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var charactersLeftView: UILabel!
    @IBOutlet weak var statusView: UITextField!
    var tweet: Tweet?
    var delegate: PostTweetViewControllerDelegate?
    
    override func viewDidLoad() {
        if let currentUser = User.currentUser {
            nameView.text = currentUser.name
            screenNameView.text = User.currentUser?.screenName
            if let profileUrl = User.currentUser?.profileUrl {
                avatarView.af_setImageWithURL(profileUrl)
            }
            if let userToReplyTo = tweet?.user {
                statusView.text = "@\(userToReplyTo.screenName!) "
            }
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
        self.statusView.becomeFirstResponder()
    }
    
    @IBAction func onCancelClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func onTweetClicked(sender: AnyObject) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        TwitterClient.sharedInstance.postStatus(tweet, status: statusView.text!, success: { (tweet) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.delegate?.postTweetViewController?(self, tweetDidPost: tweet)
            self.dismissViewControllerAnimated(true, completion: nil)
        }) { (error) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            ViewUtils.viewController(self, displayMessage: error.localizedDescription)
        }
    }
    @IBAction func onStatusEditingChanged(sender: UITextField) {
        charactersLeftView.text = "\(140 - (sender.text?.characters.count)!)"
    }
}

@objc protocol PostTweetViewControllerDelegate {
    optional func postTweetViewController(postTweetViewController: PostTweetViewController, tweetDidPost: Tweet)
}