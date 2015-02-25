//
//  TableViewController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 2/24/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit

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
            blogPosts.append(blogPost)
        }
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
        return blogPosts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TableViewCell
        
        cell.postImageView.image = UIImage(named: "placeholder")
        
        let blogPost: BlogPost = blogPosts[indexPath.row]
        cell.postLabel.text = blogPost.postTitle
        println(blogPost.postDesc)
        
        return cell
    }

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
