//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Hieu Rocker on 3/25/16.
//  Copyright © 2016 Hieu Rocker. All rights reserved.
//

import UIKit
import FontAwesome_swift

class TweetsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?

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
        TwitterClient.sharedInstance.logout()
    }
}


extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = self.tweets?[indexPath.row]
        return cell
    }
}