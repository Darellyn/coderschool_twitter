//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Hieu Rocker on 3/25/16.
//  Copyright © 2016 Hieu Rocker. All rights reserved.
//

import UIKit
import FontAwesome_swift
import MBProgressHUD

class TweetsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    var tweetDidPost: Tweet?

    override func viewDidLoad() {
        setupNavigationBar()
        setupTableView()
        loadTweets()
    }
    
    func setupNavigationBar() {
//        navigationItem.title = "@\(User.currentUser?.screenName)"
        navigationItem.backBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.fontAwesomeOfSize(30)], forState: UIControlState.Normal)
        navigationItem.backBarButtonItem?.title = String.fontAwesomeIconWithName(FontAwesome.PowerOff)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func loadTweets() {
        TwitterClient.sharedInstance.homeTimeLine({ (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error) in
            ViewUtils.viewController(self, displayMessage: error.localizedDescription)
        }
    }
    
    
    @IBAction func onLogoutClicked(sender: AnyObject) {
        ViewUtils.viewController(self, displayConfirmDialogWithTitle: nil, andMessage: "Are you sure you want to log out?", withConfirmAction: "Log Out", confirmed: {
                TwitterClient.sharedInstance.logout()
            }, withCancelAction: "No", cancelled: nil)
    }

    @IBAction func onReplyClicked(sender: UIButton) {
        let tweet = tweets?[sender.tag]
        self.performSegueWithIdentifier("postTweetSegue", sender: tweet)
    }
    
    @IBAction func onRetweetClicked(sender: UIButton) {
        let row = sender.tag
        let tweet = tweets?[row]
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        TwitterClient.sharedInstance.retweet(tweet!, success: { (retweet) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            tweet!.retweetedStatus = retweet
            self.tableView.reloadData()
            self.loadTweets()
        }) { (error) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            ViewUtils.viewController(self, displayMessage: error.localizedDescription)
        }
    }
    
    @IBAction func onFavoriteClicked(sender: UIButton) {
        let row = sender.tag
        let tweet = tweets?[row]
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        TwitterClient.sharedInstance.favorite(tweet!, favorited: !(tweet?.favorited)! ?? true, success: { (tweet) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tweets?[row] = tweet
            self.tableView.reloadData()
            self.loadTweets()
        }) { (error) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            ViewUtils.viewController(self, displayMessage: error.localizedDescription)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TweetCell" {
            if let vc = segue.destinationViewController as? TweetViewController {
                let cell = sender as! TweetCell
                let indexPath = tableView.indexPathForCell(cell)
                vc.tweet = tweets?[indexPath!.row]
                vc.delegate = self
                tableView.deselectRowAtIndexPath(indexPath!, animated: false)
            }
        } else if segue.identifier == "postTweetSegue" {
            if let vc = segue.destinationViewController as? PostTweetViewController {
                vc.delegate = self
                let tweet = sender as? Tweet
                if let tweet = tweet {
                    vc.tweet = tweet
                }
            }
        } else if segue.identifier == "viewTweetSegue" {
            if let vc = segue.destinationViewController as? TweetViewController {
                vc.delegate = self
                vc.tweet = self.tweetDidPost
            }
        }
    }
}


extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = self.tweets?[indexPath.row]
        cell.row = indexPath.row
        return cell
    }
}

extension TweetsViewController: PostTweetViewControllerDelegate {
    func postTweetViewController(postTweetViewController: PostTweetViewController, tweetDidPost: Tweet) {
        self.tweetDidReplyTweet(tweetDidPost)
    }
}

extension TweetsViewController: TweetDelegate {
    func tweetDidFavorite(tweet: Tweet) {
        self.tableView.reloadData()
    }
    func tweetDidUnFavorite(tweet: Tweet) {
        self.tableView.reloadData()
    }
    func tweetDidRetweet(tweet: Tweet) {
        self.tableView.reloadData()
    }
    func tweetDidUnRetweet(tweet: Tweet) {
        self.tableView.reloadData()
    }
    func tweetDidReplyTweet(tweet: Tweet) {
        self.tweetDidPost = tweet
        self.performSegueWithIdentifier("viewTweetSegue", sender: nil)
        tweets?.insert(tweet, atIndex: 0)
        tableView.reloadData()
        loadTweets()
    }
}