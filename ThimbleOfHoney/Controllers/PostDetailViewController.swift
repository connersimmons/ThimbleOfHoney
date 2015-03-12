//
//  PostViewController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 2/24/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!
    var postTitle: String = String()
    var postDate: String = String()
    var postDesc: String = String()
    var postLink: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = "<h2 style=\"text-align:center; text-transform: uppercase; color: #499AC7;font-family: \"YanoneKaffeesatz-Regular\", sans-serif;\">\(postTitle)</h2>"
        let date = "<h3 style=\"text-align:center; color: #609d52;font-family: \"YanoneKaffeesatz-Regular\", sans-serif;\">\(dateConversion())</h3>"
        
        var cssString = "<style type='text/css'>" +
            "img {max-width: 100%; width: auto; height: auto;}" +
            "body {background-color:#F4EFE6;}" +
            "html {font-family: \"QuattrocentoSans-Regular\", sans-serif;}" +
            "</style>"
        
        webView.loadHTMLString(title + date + cssString + postDesc, baseURL: nil)
        
        /*
        titleLabel.text = postTitle
        dateLabel.text = dateConversion()
        webView.loadHTMLString(cssString + postDesc, baseURL: nil)
        */
    }
    
    func dateConversion() -> NSString {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "ee, dd MM yyyy HH:mm:ss z"
        var dateFromString = dateFormatter.dateFromString(postDate)
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let formattedDate: String = dateFormatter.stringFromDate(dateFromString!)
        return formattedDate
    }

    @IBAction func shareAction(sender: AnyObject) {
        let link = NSURL(string: postLink)
        let vc = UIActivityViewController(activityItems: [link!], applicationActivities: nil)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
