//
//  PostsTableViewController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 2/24/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit
import Foundation

class PostsTableViewController: UITableViewController, XMLParserDelegate, UISplitViewControllerDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let rssFeed: String = "http://thimbleofhoney.dreamhosters.com/feed/"
    var xmlParser: XMLParser!
    
    var detailViewController: PostDetailViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0)
        
        menuSetup()
        
        if Reachability.isConnectedToNetwork() == true {
            print("Network Connection: Available")
        } else {
            print("Network Connection: Unavailable")
            noInternetAlert()
        }
        
        parseWebsite()
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.splitViewController!.delegate = self;
        self.splitViewController!.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        
        setupSplitViewData()
    }
    
    // MARK: XMLParserDelegate method implementation
    
    func parseWebsite() {
        let url:NSURL = NSURL(string: rssFeed)!
        xmlParser = XMLParser()
        xmlParser.delegate = self
        xmlParser.startParsingContentsOfURL(url)
    }
    
    func parsingWasFinished() {
        self.tableView.reloadData()
    }
    
    func setupSplitViewData() {
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? PostDetailViewController
            
            if xmlParser.blogPosts.count > 0 {
                self.detailViewController?.postTitle = xmlParser.blogPosts[0].postTitle
                self.detailViewController?.postDate = xmlParser.blogPosts[0].postDate
                self.detailViewController?.postDesc = xmlParser.blogPosts[0].postDesc
                self.detailViewController?.postLink = xmlParser.blogPosts[0].postLink
            } else {
                print("xmlParser.blogPosts empty")
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //removes navigation bar when keyboard appears
        navigationController?.hidesBarsWhenKeyboardAppears = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //the following line can make the dividers between table rows disappear
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        if xmlParser.blogPosts.isEmpty == false {
            return 1
        }
        else {
            let refreshLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            refreshLabel.text = "No data available. Please pull down to refresh!"
            refreshLabel.textColor = UIColor(rgb: 0x499AC7)
            refreshLabel.numberOfLines = 0;
            refreshLabel.textAlignment = NSTextAlignment.Center
            refreshLabel.font = UIFont(name: "YanoneKaffeesatz-Regular", size: 24)
            refreshLabel.sizeToFit()
            
            self.tableView.backgroundView = refreshLabel
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xmlParser.blogPosts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PostsTableViewCell
        
        let blogPost: BlogPost = xmlParser.blogPosts[indexPath.row]
        cell.postLabel.text = blogPost.postTitle
        
        let urlString = blogPost.postDesc.findFirstImage()
        ImageLoader.sharedLoader.imageForUrl(urlString as String, completionHandler:{(image: UIImage?, url: String) in
            cell.postImageView.image = image
        })
        
        return cell
    }
    
    func refresh(sender:AnyObject) {
        self.refreshControl?.addTarget(self, action: "parseWebsite", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func menuSetup() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
            // Uncomment to change the width of menu
            self.revealViewController().rearViewRevealWidth = 220
        }
    }
    
    func noInternetAlert() {
        let alertController = UIAlertController(title: "No Internet connection!",
            message: "Please connect to the Internet.",
            preferredStyle: .Alert)

        let cancelSelected = UIAlertAction(title: "Cancel", style: .Cancel){ (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let okSelected = UIAlertAction(title: "Settings", style: .Default){ (action) in
            self.openSettings()
        }
        
        alertController.addAction(cancelSelected)
        alertController.addAction(okSelected)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func openSettings() {
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)  {
        if segue.identifier == "viewpost" {
            
            let selectedRow = self.tableView.indexPathForSelectedRow?.row
            let blogPost: BlogPost = xmlParser.blogPosts[selectedRow!]
            
            let nav = segue.destinationViewController as! UINavigationController
            let viewController = nav.viewControllers[0] as! PostDetailViewController
            
            viewController.postTitle = blogPost.postTitle
            viewController.postDate = blogPost.postDate
            viewController.postDesc = blogPost.postDesc
            viewController.postLink = blogPost.postLink

            /*
            var detail: PostDetailViewController
            if let navigationController = segue.destinationViewController as? UINavigationController {
                detail = navigationController.topViewController as! PostDetailViewController
            } else {
                detail = segue.destinationViewController as! PostDetailViewController
            }
            
            if let path = tableView.indexPathForSelectedRow()?.row {
                var blogPost: BlogPost = xmlParser.blogPosts[path]
                detail.postTitle = blogPost.postTitle
                detail.postDate = blogPost.postDate
                detail.postDesc = blogPost.postDesc
                detail.postLink = blogPost.postLink
            }
            */
        }
    }
    
    // MARK: - UISplitViewControllerDelegate
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
}
