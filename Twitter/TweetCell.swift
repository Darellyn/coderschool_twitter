//
//  TweetCell.swift
//  Twitter
//
//  Created by Hieu Rocker on 3/25/16.
//  Copyright © 2016 Hieu Rocker. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {
    @IBOutlet weak var retweetTypeView: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var retweetByView: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var screenNameView: UILabel!
    @IBOutlet weak var timeView: UILabel!
    @IBOutlet weak var statusView: UILabel!
    @IBOutlet weak var replyView: UILabel!
    @IBOutlet weak var retweetView: UILabel!
    @IBOutlet weak var starView: UILabel!
    
    var tweet: Tweet? {
        didSet {
            statusView.text = tweet?.text ?? ""
            // avatarImageView.af_setImageWithURL(tweet.avatar)
        }
    }
}
