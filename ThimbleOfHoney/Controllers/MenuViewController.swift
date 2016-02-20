//
//  MenuViewController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 3/21/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    let instagramURL = "https://instagram.com/thimbleofhoneyblog/"
    let facebookURL = "https://facebook.com/ThimbleOfHoneyBlog"
    let pinterestURL = "https://pinterest.com/ThimbleOfHoney/"
    let twitterURL = "https://twitter.com/ThimbleOfHoney"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
        let app = UIApplication.sharedApplication()
        
        switch selectedCell.tag {
        case 1:
            app.openURL(NSURL(string: facebookURL)!)
        case 2:
            app.openURL(NSURL(string: instagramURL)!)
        case 3:
            app.openURL(NSURL(string: pinterestURL)!)
        case 4:
            app.openURL(NSURL(string: twitterURL)!)
        default:
            print("Relative path selected.")
        }
        
        tableView.deselectRowAtIndexPath(indexPath!, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.revealViewController().frontViewController.view.userInteractionEnabled = false
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.revealViewController().frontViewController.view.userInteractionEnabled = true
    }
}
