//
//  TableViewController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 2/24/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit
import Foundation

class TableViewController: UITableViewController, NSXMLParserDelegate {

    var parser: NSXMLParser = NSXMLParser()
    var blogPosts: [BlogPost] = []
    var postTitle: String = String()
    var postLink: String = String()
    var postDesc: String = String()
    var curElement: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url:NSURL = NSURL(string: "http://thimbleofhoney.com/rss")!
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.parse()
    }
    
    // MARK: - NSXMLParserDelegate methods
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        curElement = elementName
        if elementName == "item" {
            postTitle = String()
            postLink = String()
            postDesc = String()
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if (!data.isEmpty) {
            if curElement == "title" {
                postTitle += data
            } else if curElement == "link" {
                postLink += data
            } else if curElement == "description" {
                postDesc += data
            }
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if elementName == "item" {
            let blogPost: BlogPost = BlogPost()
            blogPost.postTitle = postTitle
            blogPost.postLink = postLink
            blogPost.postDesc = postDesc
            //blogPost.postThumbnail = getThumbnail(postDesc)
            blogPosts.append(blogPost)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func getThumbnail() -> UIImage {
        
    }
    */

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogPosts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TableViewCell
        
        let blogPost: BlogPost = blogPosts[indexPath.row]
        cell.postLabel.text = blogPost.postTitle
        
        //asyncLoadPostImage(blogPost, imageView: cell.postImageView)
        
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
    
    /*
    func asyncLoadPostImage(blogPost: BlogPost, imageView: UIImageView) {
        let downloadQueue = dispatch_queue_create("com.thimbleofhoney.processdownload", nil)
    
        dispatch_async(downloadQueue) {
            if blogPost.postDesc.isEmpty == false {
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
                
                if imageSource != "" {
                    var url = NSURL(string: imageSource)
                    if url != nil{
                        var imageData = NSData(contentsOfURL: url!)
                        imageView.image = UIImage(data: imageData!)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    */

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
         return 100
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)  {
        if segue.identifier == "viewpost" {
            let selectedRow = tableView.indexPathForSelectedRow()?.row
            let blogPost: BlogPost = blogPosts[selectedRow!]
            let viewController = segue.destinationViewController as PostViewController
            viewController.postLink = blogPost.postLink
        }
    }
}
