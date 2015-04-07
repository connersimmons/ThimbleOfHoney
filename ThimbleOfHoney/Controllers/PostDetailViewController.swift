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
    var currentSelection: NSObject = NSObject()
    var detailsDataSource: NSArray = NSArray()
    var detailIndex: Int = Int()
    var postTitle: String = String()
    var postDate: String = String()
    var postDesc: String = String()
    var postLink: String = String()
    var optionIndices: NSMutableIndexSet = NSMutableIndexSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.optionIndices = NSMutableIndexSet(index: 0)
        
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
        let colors: NSArray = [UIColor(red:0.376 , green:0.615 , blue:0.321 , alpha:0.85 ),
                               UIColor(red:0.376 , green:0.615 , blue:0.321 , alpha:0.85)]
        
        let sidebar: RNFrostedSidebar = RNFrostedSidebar(images: images, selectedIndices: optionIndices, borderColors: colors)
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
    
    func sidebar(sidebar: RNFrostedSidebar!, didEnable itemEnabled: Bool, itemAtIndex index: UInt) {
        if itemEnabled {
            self.optionIndices.addIndex(Int(index))
        }
        else {
            self.optionIndices.removeIndex(Int(index))
        }
    }
    
    func shareAction() {
        let message = "Check out this post from Thimble of Honey!"
        let link = NSURL(string: postLink)
        
        let activityItems = [message, link!]
        let vc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        //UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(20)]
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func addToFavorites() {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Favorites", inManagedObjectContext: context)
        
        var newFavorite = Favorites(entity: entity!, insertIntoManagedObjectContext: context)
        newFavorite.postTitle = postTitle
        newFavorite.postDate = postDate
        newFavorite.postDesc = postDesc
        newFavorite.postLink = postLink
        
        context.save(nil)
        println(newFavorite)
        println("Object saved.")
    }
    
    

    @IBAction func handleSwipeRight(sender: UISwipeGestureRecognizer) {
        
        if detailIndex != 0 {
            loadArticleForIndex(detailIndex--)
            
        }
        
        postTitle = detailsDataSource[detailIndex].postTitle
        postDate =  detailsDataSource[detailIndex].postDate
        postDesc = detailsDataSource[detailIndex].postDesc
    }
    
    func loadArticleForIndex(index: Int) {
        
    }
    
    /*
    @IBAction func handleSwipeLeft(sender: UISwipeGestureRecognizer) {
        
    }
    */
}
