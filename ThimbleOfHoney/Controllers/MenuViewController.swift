//
//  MenuViewController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 3/21/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    let facebookURL = "fb://profile/909558142401429"
    let facebookURLWeb = "https://facebook.com/ThimbleOfHoneyBlog"
    
    let instagramURL = "instagram://user?username=thimbleofhoneyblog"
    let instagramURLWeb = "https://instagram.com/thimbleofhoneyblog/"
    
    let pinterestURL = "pinterest://user/ThimbleOfHoney/"
    let pinterestURLWeb = "https://pinterest.com/ThimbleOfHoney/"
    
    let twitterURL = "twitter://user?screen_name=ThimbleOfHoney"
    let twitterURLWeb = "https://twitter.com/ThimbleOfHoney"
    
    
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
        
        let fbInstalled = schemeAvailable("fb://")
        let igInstalled = schemeAvailable("instagram://")
        let pnInstalled = schemeAvailable("pinterest://")
        let twInstalled = schemeAvailable("twitter://")
        
        switch selectedCell.tag {
        case 1:
            if fbInstalled {
                app.openURL(NSURL(string: facebookURL)!)
            } else {
                app.openURL(NSURL(string: facebookURLWeb)!)
            }
        case 2:
            if igInstalled {
                app.openURL(NSURL(string: instagramURL)!)
            } else {
                app.openURL(NSURL(string: instagramURLWeb)!)
            }
        case 3:
            if pnInstalled {
                app.openURL(NSURL(string: pinterestURL)!)
            } else {
                app.openURL(NSURL(string: pinterestURLWeb)!)
            }
        case 4:
            if twInstalled {
                app.openURL(NSURL(string: twitterURL)!)
            } else {
                app.openURL(NSURL(string: twitterURLWeb)!)
            }
        default:
            print("Relative path selected.")
        }
        
        tableView.deselectRowAtIndexPath(indexPath!, animated: true)
    }
    
    func schemeAvailable(scheme: String) -> Bool {
        if let url = NSURL.init(string: scheme) {
            return UIApplication.sharedApplication().canOpenURL(url)
        }
        return false
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
