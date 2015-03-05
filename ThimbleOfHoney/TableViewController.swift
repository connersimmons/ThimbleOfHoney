//
//  TableViewController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 2/24/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit
import Foundation

class TableViewController: UITableViewController, XMLParserDelegate {
    
    var xmlParser: XMLParser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //the following line can make the dividers between table rows disappear
        //self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let url:NSURL = NSURL(string: "http://thimbleofhoney.com/rss")!
        xmlParser = XMLParser()
        xmlParser.delegate = self
        xmlParser.startParsingContentsOfURL(url)
    }
    
    // MARK: XMLParserDelegate method implementation
    
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xmlParser.blogPosts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TableViewCell
        
        let blogPost: BlogPost = xmlParser.blogPosts[indexPath.row]
        cell.postLabel.text = blogPost.postTitle
        
        var urlString = findFirstImage(blogPost)
        ImageLoader.sharedLoader.imageForUrl(urlString, completionHandler:{(image: UIImage?, url: String) in
            cell.postImageView.image = image
            
            //below makes the images into circles, replace the line above with these three if you want that
            /*
            cell.postImageView.image = image
            cell.postImageView.layer.cornerRadius = cell.postImageView.frame.size.width / 2;
            cell.postImageView.clipsToBounds = true
            */
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

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
         return 100
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)  {
        if segue.identifier == "viewpost" {
            let selectedRow = tableView.indexPathForSelectedRow()?.row
            let blogPost: BlogPost = xmlParser.blogPosts[selectedRow!]
            let viewController = segue.destinationViewController as PostViewController
            viewController.postTitle = blogPost.postTitle
            viewController.postDate = blogPost.postDate
            viewController.postDesc = blogPost.postDesc
            viewController.postLink = blogPost.postLink
            
            //can be used to hide the tab bar when you are in the detail view of the tableview controller
            viewController.hidesBottomBarWhenPushed = true
        }
    }
}
