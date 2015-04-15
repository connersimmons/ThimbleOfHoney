//
//  PostDetailViewController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 2/24/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit
import iAd

class PostDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var webView: UIWebView!

    var postTitle: String = String()
    var postDate: String = String()
    var postDesc: String = String()
    var postLink: String = String()
    var device: UIDevice = UIDevice.currentDevice()
    var currentDeviceId: NSString = NSString()
    //var isFavorited: Bool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentDeviceId = device.identifierForVendor.UUIDString
        //isFavoritedPost()
        configureNavBar()
        
        let title = "<h2 style=\"text-align:center; text-transform: uppercase; color: #499AC7;font-family: 'Yanone Kaffeesatz', sans-serif;\">\(postTitle)</h2>"
        let date = "<h3 style=\"text-align:center; color: #609d52;font-family: 'Yanone Kaffeesatz', sans-serif;\">\(dateConversion())</h3>"
        
        var cssString = "<style type='text/css'>" +
            "img {max-width: 100%; width: auto; height: auto;}" +
            "body {background-color:#F4EFE6;}" +
            "html {font-family: 'Quattrocento Sans', sans-serif;}" +
            "</style>"
        
        webView.loadHTMLString(title + date + cssString + postDesc, baseURL: nil)
        
        self.canDisplayBannerAds = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let font = UIFont(name: "RougeScript-Regular", size: 32)
        if let font = font {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(nil, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dateConversion() -> NSString {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "ee, dd MM yyyy HH:mm:ss z"
        var dateFromString = dateFormatter.dateFromString(postDate)
        
        dateFormatter.dateFormat = "d MMMM yyyy"
        let formattedDate: String = dateFormatter.stringFromDate(dateFromString!)
        return formattedDate
    }
    
    func configureNavBar() {
        var shareImage = UIImage(named: "ios7-upload-outline")
        var starImage = UIImage(named: "ios7-star-outline")
        /*
        println(isFavorited)
        if isFavorited {
            starImage = UIImage(named: "ios7-star-full")
        }
        */
        var share = UIBarButtonItem(image: shareImage, style: UIBarButtonItemStyle.Plain, target: self, action: "shareAction")
        var favorite = UIBarButtonItem(image: starImage, style: UIBarButtonItemStyle.Plain, target: self, action: "addToFavorites")
        
        self.navigationItem.rightBarButtonItems = [share, favorite]
    }
    
    func shareAction() {
        let message = "Check out this post from Thimble of Honey!"
        let link = NSURL(string: postLink)
        
        let activityItems = [message, link!]
        let vc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        let font = UIFont(name: "YanoneKaffeesatz-Regular", size: 18)
        if let font = font {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    /*
    func isFavoritedPost() -> Bool{
        var query: PFQuery = PFQuery(className: "Favorite")
        query.whereKey("deviceId", equalTo: currentDeviceId)
        query.whereKey("postTitle", equalTo: postTitle)
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            println(objects)
            if error != nil {
                println(error)
            }
            else {
                if objects!.isEmpty {
                    self.isFavorited = false
                }
                else {
                    self.isFavorited = true
                }
            }
        }
        return self.isFavorited
    }
    */
    /*
    func addToFavorites() {
        if isFavoritedPost() {
            let alertController = UIAlertController(title: "Oops!",
                message: "\"\(self.postTitle)\" is already in your favorites.",
                preferredStyle: .Alert)
            
            let okSelected = UIAlertAction(title: "OK", style: .Default){ (action) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            alertController.addAction(okSelected)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            var object = PFObject(className: "Favorite")
            object.addObject(currentDeviceId, forKey: "deviceId")
            object.addObject(self.postTitle, forKey: "postTitle")
            object.addObject(self.postDate, forKey: "postDate")
            object.addObject(self.postDesc, forKey: "postDesc")
            object.addObject(self.postLink, forKey: "postLink")
            object.saveInBackground()
        }
    }
    */
    
    func addToFavorites() {
        var query: PFQuery = PFQuery(className: "Favorite")
        query.whereKey("deviceId", equalTo: currentDeviceId)
        query.whereKey("postTitle", equalTo: postTitle)
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error != nil {
                println(error)
            }
            else {
                if objects!.isEmpty {
                    var object = PFObject(className: "Favorite")
                    object.addObject(self.currentDeviceId, forKey: "deviceId")
                    object.addObject(self.postTitle, forKey: "postTitle")
                    object.addObject(self.postDate, forKey: "postDate")
                    object.addObject(self.postDesc, forKey: "postDesc")
                    object.addObject(self.postLink, forKey: "postLink")
                    object.saveInBackground()
                    //self.isFavorited == true
                    //self.configureNavBar()
                }
                else {
                    let alertController = UIAlertController(title: "Oops!",
                        message: "\"\(self.postTitle)\" is already in your favorites.",
                        preferredStyle: .Alert)
                    
                    let okSelected = UIAlertAction(title: "OK", style: .Default){ (action) in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    
                    alertController.addAction(okSelected)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    //self.configureNavBar()
                }
            }
        }
    }
    
}
