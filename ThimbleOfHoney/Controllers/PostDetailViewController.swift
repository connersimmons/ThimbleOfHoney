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
    var isFavorited: Bool = Bool()
    var shareImage: UIImage = UIImage(named: "ios7-upload-outline")!
    var starImage: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentDeviceId = device.identifierForVendor!.UUIDString
        
        let title = "<h2 style=\"text-align:center; text-transform: uppercase; color: #499AC7;font-family: 'Yanone Kaffeesatz', sans-serif;\">\(postTitle)</h2>"
        let date = "<h3 style=\"text-align:center; color: #609d52;font-family: 'Yanone Kaffeesatz', sans-serif;\">\(dateConversion())</h3>"
        
        let cssString = "<style type='text/css'>" +
            "img {max-width: 100%; display: block; margin-left: auto; margin-right: auto}" +
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
        
        isFavoritedPost()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dateConversion() -> NSString {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "ee, dd MM yyyy HH:mm:ss z"
        
        if let parsedDateTimeString = dateFormatter.dateFromString(postDate) {
            dateFormatter.dateFormat = "d MMMM yyyy"
            return dateFormatter.stringFromDate(parsedDateTimeString)
        } else {
            return "Could not parse date"
        }
    }
    
    func configureNavBar() {
        let share = UIBarButtonItem(image: shareImage, style: UIBarButtonItemStyle.Plain, target: self, action: "shareAction")
        let favorite = UIBarButtonItem(image: starImage, style: UIBarButtonItemStyle.Plain, target: self, action: "addToFavorites")
        
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
    
    func isFavoritedPost() {
        if findQuery().countObjects() > 0 {
            self.starImage = UIImage(named: "ios7-star-full")!
            self.isFavorited = true
        }
        else {
            self.starImage = UIImage(named: "ios7-star-outline")!
            self.isFavorited = false
        }
        configureNavBar()
    }
    
    func addToFavorites() {
        if findQuery().countObjects() > 0 {
            self.starImage = UIImage(named: "ios7-star-outline")!
            self.isFavorited = false
            
            let object = findQuery().getFirstObject()
            object?.deleteInBackground()
        }
        else {
            self.starImage = UIImage(named: "ios7-star-full")!
            
            let object = PFObject(className: "Favorite")
            object.addObject(self.currentDeviceId, forKey: "deviceId")
            object.addObject(self.postTitle, forKey: "postTitle")
            object.addObject(self.postDate, forKey: "postDate")
            object.addObject(self.postDesc, forKey: "postDesc")
            object.addObject(self.postLink, forKey: "postLink")
            object.saveInBackground()
            
            self.isFavorited = true
        }
        configureNavBar()
    }
    
    func findQuery() -> PFQuery {
        let query: PFQuery = PFQuery(className: "Favorite")
        print("postTitle: \(postTitle);   currentDeviceId: \(currentDeviceId)")
        query.whereKey("deviceId", equalTo: currentDeviceId)
        query.whereKey("postTitle", equalTo: postTitle)
        return query
    }
}
