//
//  SocialViewController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 3/7/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController {
    
    let instagramURL = "https://instagram.com/thimbleofhoneyblog/"
    let facebookURL = "https://www.facebook.com/ThimbleOfHoneyBlog"
    let pinterestURL = "https://www.pinterest.com/ThimbleOfHoney/"
    let twitterURL = "https://twitter.com/ThimbleOfHoney"
    var selectedURL: String = String()

    @IBOutlet weak var instagramBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var pinterestBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func facebookAction(sender: AnyObject) {
        selectedURL = facebookURL
        self.performSegueWithIdentifier("viewsocial", sender: sender)
    }
    
    @IBAction func instagramAction(sender: AnyObject) {
        selectedURL = instagramURL
        self.performSegueWithIdentifier("viewsocial", sender: sender)
    }
    
    @IBAction func pinterestAction(sender: AnyObject) {
        selectedURL = pinterestURL
        self.performSegueWithIdentifier("viewsocial", sender: sender)
    }
    
    @IBAction func twitterAction(sender: AnyObject) {
        selectedURL = twitterURL
        self.performSegueWithIdentifier("viewsocial", sender: sender)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "viewsocial" {
            let viewController = segue.destinationViewController as SocialWVController
            viewController.socialLink = selectedURL
        }
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
