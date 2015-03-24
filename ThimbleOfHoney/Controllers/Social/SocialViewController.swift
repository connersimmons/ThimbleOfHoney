//
//  SocialViewController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 3/7/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController, UIWebViewDelegate {
    
    let instagramURL = "https://instagram.com/thimbleofhoneyblog/"
    let facebookURL = "https://www.facebook.com/ThimbleOfHoneyBlog"
    let pinterestURL = "https://www.pinterest.com/ThimbleOfHoney/"
    let twitterURL = "https://twitter.com/ThimbleOfHoney"
    var selectedURL: String = String()

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Do any additional setup after loading the view.
        switch menuButton.tag {
        case 0:
            selectedURL = facebookURL
        case 1:
            selectedURL = instagramURL
        case 2:
            selectedURL = pinterestURL
        case 3:
            selectedURL = twitterURL
        default:
            println("default case entered")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
