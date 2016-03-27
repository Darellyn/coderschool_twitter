//
//  Media.swift
//  Twitter
//
//  Created by Hieu Rocker on 3/27/16.
//  Copyright © 2016 Hieu Rocker. All rights reserved.
//

import UIKit

class Media: NSObject {
    var id: Int64?
    var url: NSURL?
    var mediaUrl: NSURL?
    var mediaSmallUrl: NSURL?
    var mediaSmallWidth: Int?
    var mediaSmallHeight: Int?
    var mediaLargeUrl: NSURL?
    var mediaLargeWidth: Int?
    var mediaLargeHeight: Int?
    var ratio: CGFloat? {
        get {
            if let mediaSmallWidth = mediaSmallWidth {
                return CGFloat(mediaSmallHeight!) / CGFloat(mediaSmallWidth)
            } else {
                return nil
            }
        }
    }
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? Int64
        let urlData = dictionary["url"] as? String
        if let urlData = urlData {
            url = NSURL(string: urlData)
        }
        let mediaUrlData = dictionary["media_url_https"] as? String
        if let mediaUrlData = mediaUrlData {
            mediaUrl = NSURL(string: mediaUrlData)
            let small = ((dictionary["sizes"] as? NSDictionary)?["small"] as? NSDictionary)
            if let small = small {
                mediaSmallWidth = small["w"] as? Int ?? 0
                mediaSmallHeight = small["h"] as? Int ?? 0
                mediaSmallUrl = NSURL(string: "\(mediaUrlData):small")
            }
            let large = ((dictionary["sizes"] as? NSDictionary)?["large"] as? NSDictionary)
            if let large = large {
                mediaLargeWidth = large["w"] as? Int ?? 0
                mediaLargeHeight = large["h"] as? Int ?? 0
                mediaLargeUrl = NSURL(string: "\(mediaUrlData):large")
            }
        }
    }
}
