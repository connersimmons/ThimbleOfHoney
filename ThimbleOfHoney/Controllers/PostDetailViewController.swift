//
//  PostDetailViewController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 2/24/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit
import CoreData
import RNFrostedSidebar

class PostDetailViewController: UIViewController, UIGestureRecognizerDelegate, RNFrostedSidebarDelegate {
    
    @IBOutlet weak var moreButton: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!

    var postTitle: String = String()
    var postDate: String = String()
    var postDesc: String = String()
    var postLink: String = String()
    var sidebar: RNFrostedSidebar = RNFrostedSidebar(images: nil, selectedIndices: nil, borderColors: nil)
    var optionIndices: NSMutableIndexSet = NSMutableIndexSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.optionIndices = NSMutableIndexSet(index: 0)
        
        let title = "<h2 style=\"text-align:center; text-transform: uppercase; color: #499AC7;font-family: 'Yanone Kaffeesatz', sans-serif;\">\(postTitle)</h2>"
        let date = "<h3 style=\"text-align:center; color: #609d52;font-family: 'Yanone Kaffeesatz', sans-serif;\">\(dateConversion())</h3>"
        
        var cssString = "<style type='text/css'>" +
            "img {max-width: 100%; width: auto; height: auto;}" +
            "body {background-color:#F4EFE6;}" +
            "html {font-family: 'Quattrocento Sans', sans-serif;}" +
            "</style>"
        
        webView.loadHTMLString(title + date + cssString + postDesc, baseURL: nil)

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

    @IBAction func moreAction(sender: AnyObject) {
        let images: [UIImage] = [UIImage(named: "ios7-upload-outline")!,
                                 UIImage(named: "ios7-star-outline")!]
        let colors: [UIColor] = [UIColor(red:0.376 , green:0.615 , blue:0.321 , alpha:0.85 ),
                               UIColor(red:0.376 , green:0.615 , blue:0.321 , alpha:0.85)]
        sidebar = RNFrostedSidebar(images: images, selectedIndices: nil, borderColors: colors)
        sidebar.delegate = self
        sidebar.showFromRight = true
        sidebar.show()
    }
    
    func sidebar(sidebar: RNFrostedSidebar!, didTapItemAtIndex index: UInt) {
        if index == 0 {
            shareAction()
        }
        else if index == 1 {
            addToFavorites()
        }
    }
    
    /*
    func sidebar(sidebar: RNFrostedSidebar!, didEnable itemEnabled: Bool, itemAtIndex index: UInt) {
        if itemEnabled {
            self.optionIndices.addIndex(Int(index))
        }
        else {
            self.optionIndices.removeIndex(Int(index))
        }
    }
    */
    
    func shareAction() {
        let message = "Check out this post from Thimble of Honey!"
        let link = NSURL(string: postLink)
        
        let activityItems = [message, link!]
        let vc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        //UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(20)]
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func addToFavorites() {
        var device: UIDevice = UIDevice.currentDevice()
        var currentDeviceId: NSString = device.identifierForVendor.UUIDString
        
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
                    object.addObject(currentDeviceId, forKey: "deviceId")
                    object.addObject(self.postTitle, forKey: "postTitle")
                    object.addObject(self.postDate, forKey: "postDate")
                    object.addObject(self.postDesc, forKey: "postDesc")
                    object.addObject(self.postLink, forKey: "postLink")
                    object.saveInBackground()
                    
                    self.sidebar.dismiss()
                }
                else {
                    self.sidebar.dismiss()
                    let alertController = UIAlertController(title: "Oops!",
                        message: "\"\(self.postTitle)\" is already in your favorites.",
                        preferredStyle: .Alert)
                    
                    let okSelected = UIAlertAction(title: "OK", style: .Default){ (action) in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    
                    alertController.addAction(okSelected)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
