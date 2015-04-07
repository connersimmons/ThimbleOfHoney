//
//  PostsTableViewController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 2/24/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit
import Foundation
import IJReachability

class PostsTableViewController: UITableViewController, XMLParserDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var xmlParser: XMLParser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuSetup()
        checkForInternetConnection()
        
        // Do any additional setup after loading the view.
        parseWebsite()
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    /*
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar = searchDisplayController?.searchBar
        searchBar.frame = CGRectMake(0,max(0,scrollView.contentOffset.y),320,44)
    }
    */
    
    // MARK: XMLParserDelegate method implementation
    
    func parseWebsite() {
        let url:NSURL = NSURL(string: "http://thimbleofhoney.com/rss")!
        xmlParser = XMLParser()
        xmlParser.delegate = self
        xmlParser.startParsingContentsOfURL(url)
    }
    
    func parsingWasFinished() {
        self.tableView.reloadData()
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
            refreshLabel.textColor = UIColor.blackColor()
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
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as PostsTableViewCell
        
        let blogPost: BlogPost = xmlParser.blogPosts[indexPath.row]
        cell.postLabel.text = blogPost.postTitle
        
        var urlString = findFirstImage(blogPost)
        ImageLoader.sharedLoader.imageForUrl(urlString, completionHandler:{(image: UIImage?, url: String) in
            cell.postImageView.image = image
        })
        
        return cell
    }
    
    func findFirstImage(blogPost: BlogPost) -> NSString {
        let htmlContent = blogPost.postDesc as NSString
        var imageSource = ""
        
        let rangeOfString = NSMakeRange(0, htmlContent.length)
        let regex = NSRegularExpression(pattern: "(<img.*?src=\")(.*?)(\".*?>)", options: nil, error: nil)
            
        if htmlContent.length > 0 {
           let match = regex?.firstMatchInString(htmlContent, options: nil, range: rangeOfString)
                
           if match != nil {
                var imageURL = htmlContent.substringWithRange(match!.rangeAtIndex(2)) as NSString
                imageURL = imageURL.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                imageSource = imageURL
           }
        }
        return imageSource
    }
    
    func refresh(sender:AnyObject) {
        self.refreshControl?.backgroundColor = UIColor.whiteColor()
        self.refreshControl?.tintColor = UIColor.blackColor()
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
    
    func checkForInternetConnection() {
        if IJReachability.isConnectedToNetwork(){
            println("Network Connection: Available")
        }
        else {
            println("Network Connection: Unavailable")
            noInternetAlert()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)  {
        if segue.identifier == "viewpost" {
            let viewController = segue.destinationViewController as PostDetailViewController
            /*
            let selectedRow = self.tableView.indexPathForSelectedRow()?.row
            var blogPost: BlogPost = xmlParser.blogPosts[selectedRow!]

            viewController.postTitle = blogPost.postTitle
            viewController.postDate = blogPost.postDate
            viewController.postDesc = blogPost.postDesc
            viewController.postLink = blogPost.postLink
            */
            let selectedRow = self.tableView.indexPathForSelectedRow()
            var blogPost: BlogPost = xmlParser.blogPosts[selectedRow!.row]
            viewController.currentSelection = selectedRow!
            viewController.detailsDataSource = xmlParser.blogPosts
            viewController.detailIndex = selectedRow!.row
            viewController.postTitle = blogPost.postTitle
            viewController.postDate = blogPost.postDate
            viewController.postDesc = blogPost.postDesc
            viewController.postLink = blogPost.postLink
        }
    }
}
