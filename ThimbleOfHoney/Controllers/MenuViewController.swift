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
    let facebookURL = "https://www.facebook.com/ThimbleOfHoneyBlog"
    let pinterestURL = "https://www.pinterest.com/ThimbleOfHoney/"
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
        let indexPath = tableView.indexPathForSelectedRow()
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
        
        println(selectedCell.tag)
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
            println("Relative path selected.")
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
