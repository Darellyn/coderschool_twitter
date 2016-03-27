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
    
    class func viewController(viewController: UIViewController, displayConfirmDialogWithTitle title: String?,
                              andMessage message: String, withConfirmAction: String, confirmed: (()->())?, withCancelAction: String, cancelled: (()->())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: withCancelAction, style: .Cancel, handler: { (action: UIAlertAction!) in
            cancelled?()
        }))
        
        alert.addAction(UIAlertAction(title: withConfirmAction, style: .Destructive, handler: { (action: UIAlertAction!) in
            confirmed?()
        }))
        
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}
