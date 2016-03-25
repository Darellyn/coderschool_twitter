//
//  ViewUtils.swift
//  Twitter
//
//  Created by Hieu Rocker on 3/25/16.
//  Copyright © 2016 Hieu Rocker. All rights reserved.
//

import UIKit

class ViewUtils: NSObject {

    class func viewController(viewController: UIViewController, displayMessage: String) {
        let alertController = UIAlertController(title: "Alert", message: displayMessage, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
}
