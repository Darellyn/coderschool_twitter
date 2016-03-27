//
//  ViewController.swift
//  Twitter
//
//  Created by Hieu Rocker on 3/25/16.
//  Copyright © 2016 Hieu Rocker. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLoginClicked(sender: AnyObject) {
        login()
    }
    
    func login() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        TwitterClient.sharedInstance.login({
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            ViewUtils.viewController(self, displayMessage: error.localizedDescription)
        }
    }
}

