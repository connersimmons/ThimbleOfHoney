//
//  AboutMeViewController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 3/3/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController, XMLParserDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!
    var xmlParser: XMLParser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuSetup()
        
        // Do any additional setup after loading the view.
        let aboutMeURL = NSURL(string:"http://thimbleofhoney.com/about")
        let htmlString = NSData(contentsOfURL: aboutMeURL!)
        var dataString: NSString = NSString(data: htmlString!, encoding: NSUTF8StringEncoding)!
        
        let aboutMeDesc = findAboutMeContent(dataString)
        
        var cssString = "<style type='text/css'>" +
            "img {max-width: 100%; width: auto; height: auto;}" +
            "body {background-color:#f4efe6;}" +
            "html {font-family: 'Quattrocento Sans', sans-serif;}" +
            "</style>"
        
        webView.loadHTMLString(cssString + (aboutMeDesc as String), baseURL: nil)
    }
    
    func menuSetup() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parsingWasFinished() {
        self.reloadInputViews()
    }
    
    func findAboutMeContent(html: NSString) -> NSString {
        let htmlContent = html
        var description = ""
        
        let rangeOfString = NSMakeRange(0, htmlContent.length)
        let regex = NSRegularExpression(pattern: "(<section class=\"content\".*?>)(<p>.*?<h2>Contact Information</h2>.*?</p>)", options: nil, error: nil)
        
        if htmlContent.length > 0 {
            let match = regex?.firstMatchInString(htmlContent as String, options: nil, range: rangeOfString)
            
            if match != nil {
                var aboutMeDesc = htmlContent.substringWithRange(match!.rangeAtIndex(2)) as NSString
                description = aboutMeDesc as String
            }
        }
        return description
    }
}
