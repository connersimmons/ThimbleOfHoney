//
//  XMLParser.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 3/3/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit

@objc protocol XMLParserDelegate{
    func parsingWasFinished()
}

class XMLParser: NSObject, NSXMLParserDelegate {
    
    var parser: NSXMLParser = NSXMLParser()
    var blogPosts: [BlogPost] = []
    var postTitle: String = String()
    var postLink: String = String()
    var postDesc: String = String()
    var postDate: String = String()
    var curElement: String = String()
    var parseError: NSError?
    
    var delegate : XMLParserDelegate?
    
    func startParsingContentsOfURL(rssURL: NSURL) {
        let parser = NSXMLParser(contentsOfURL: rssURL)
        parser?.delegate = self
        parser?.parse()
    }
    
    //MARK: NSXMLParserDelegate method implementation
    func parserDidEndDocument(parser: NSXMLParser) {
        delegate?.parsingWasFinished()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        curElement = elementName
        if elementName == "item" {
            postTitle = String()
            postLink = String()
            postDesc = String()
            postDate = String()
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        let data = string!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if (!data.isEmpty) {
            if curElement == "title" {
                postTitle += data
            } else if curElement == "link" {
                postLink += data
            } else if curElement == "content:encoded" {
                postDesc += data
            } else if curElement == "pubDate" {
                postDate += data
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let blogPost: BlogPost = BlogPost()
            blogPost.postTitle = postTitle
            blogPost.postLink = postLink
            blogPost.postDesc = postDesc
            blogPost.postDate = postDate
            blogPosts.append(blogPost)
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        self.parseError = parseError
    }
    
}
