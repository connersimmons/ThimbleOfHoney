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
        
        if Reachability.isConnectedToNetwork() == true {
            print("Network Connection: Available")
            
            let aboutMeURL = NSURL(string:"http://thimbleofhoney.dreamhosters.com/about-me/")
            let htmlString = NSData(contentsOfURL: aboutMeURL!)
            let dataString: NSString = NSString(data: htmlString!, encoding: NSUTF8StringEncoding)!
            
            let aboutMeDesc = findAboutMeContent(dataString)
            
            let cssString = "<style type='text/css'>" +
                "img {max-width: 100%; width: auto; height: auto;}" +
                "html {font-family: 'Quattrocento Sans', sans-serif;}" +
            "</style>"
            
            webView.loadHTMLString(cssString + (aboutMeDesc as String), baseURL: nil)
        } else {
            print("Network Connection: Unavailable")
            noInternetAlert()
        }
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
    
    func findAboutMeContent(html: NSString) -> NSString {
        let htmlContent = html
        var description = ""
        
        let rangeOfString = NSMakeRange(0, htmlContent.length)
        let pattern: String = "(<div class=\"entry-content\" itemprop=\"text\"><p>)([\\s\\S]+?)(</div>)"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        
        if htmlContent.length > 0 {
            let match = regex?.firstMatchInString(htmlContent as String, options: [], range: rangeOfString)
            
            if match != nil {
                let aboutMeDesc = htmlContent.substringWithRange(match!.rangeAtIndex(2)) as NSString
                description += aboutMeDesc as String
            }
        }
        return description
    }
}
