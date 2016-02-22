//
//  FavoritesTableViewController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 4/7/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit
import CoreData
import ReachabilitySwift

class FavoritesTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var parseData: NSMutableArray! = NSMutableArray()
    var detailViewController: PostDetailViewController? = nil
    var isWaiting = true
    var reachability: Reachability!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0)
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.splitViewController!.delegate = self
        self.splitViewController!.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        
        menuSetup()
        
        let reachability = try! Reachability.reachabilityForInternetConnection()
        
        if reachability.currentReachabilityStatus == .NotReachable {
            print("Network Connection: Unavailable")
            noInternetAlert()
        } else {
            print("Network Connection: Available")
            loadData()
        }
        
        setupSplitViewData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func loadData() {
        let device: UIDevice = UIDevice.currentDevice()
        let currentDeviceId: NSString = device.identifierForVendor!.UUIDString
        
        parseData.removeAllObjects()
        
        let query: PFQuery = PFQuery(className:"Favorite")
        query.whereKey("deviceId", equalTo: currentDeviceId)
        query.orderByAscending("createdAt")
        
        let tempData = query.findObjects() as! [PFObject]
        parseData = NSMutableArray(array: tempData)
        parseData.reverseObjectEnumerator().allObjects
        
        /*
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
        
            if error == nil {
                for object in objects! {
                    let post: PFObject = object as! PFObject
                    self.parseData.addObject(post)
                }
        
                let array: NSArray = self.parseData.reverseObjectEnumerator().allObjects
                self.parseData = NSMutableArray(array: array)
                self.tableView.reloadData()
                self.isWaiting = false
        
            }
        }
        */
    }
    
    func menuSetup() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    func setupSplitViewData() {
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? PostDetailViewController
            
            if self.parseData.count > 0 {
                let post: PFObject = self.parseData.objectAtIndex(0) as! PFObject
                
                self.detailViewController?.postTitle = post["postTitle"]!.objectAtIndex(0) as! String
                self.detailViewController?.postDate = post["postDate"]!.objectAtIndex(0) as! String
                self.detailViewController?.postDesc = post["postDesc"]!.objectAtIndex(0) as! String
                self.detailViewController?.postLink = post["postLink"]!.objectAtIndex(0) as! String
            } else  {
                print("parseData empty")
            }
        }
        
    }
    
    func refresh(sender:AnyObject) {
        self.refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl?.endRefreshing()
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
    
    // MARK: - Table View Delegate
    
    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell {
        let cell:PostsTableViewCell = tableView!.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath!) as! PostsTableViewCell
        let post: PFObject = self.parseData.objectAtIndex(indexPath!.row) as! PFObject
        
        let title: AnyObject = post["postTitle"]!.objectAtIndex(0)
        cell.postLabel.text = title as? String
        
        let image: AnyObject = post["postDesc"]!.objectAtIndex(0)
        let urlString = (image as! String).findFirstImage()
        ImageLoader.sharedLoader.imageForUrl(urlString as String, completionHandler:{(image: UIImage?, url: String) in
            cell.postImageView.image = image
        })
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let refreshLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        if parseData.count > 0 {
            self.tableView.backgroundView = nil
            return 1
        }
        else {
            refreshLabel.hidden = false
            refreshLabel.text = "No favorite posts yet."
            refreshLabel.textColor = UIColor(rgb: 0x499AC7)
            refreshLabel.numberOfLines = 0;
            refreshLabel.textAlignment = NSTextAlignment.Center
            refreshLabel.font = UIFont(name: "YanoneKaffeesatz-Regular", size: 24)
            refreshLabel.sizeToFit()
            
            self.tableView.backgroundView = refreshLabel
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parseData.count
    }
    
    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
        
        switch editingStyle {
            
        case .Delete:
            let selectedQuoteFromFavourites: PFObject = self.parseData.objectAtIndex(indexPath!.row) as! PFObject
            selectedQuoteFromFavourites.deleteInBackground()
            self.parseData.removeObjectAtIndex(indexPath!.row)
            self.tableView.reloadData()
            
        default:
            return
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "viewfavorite" {
            //let viewController = segue.destinationViewController as! PostDetailViewController
            let selectedRow = self.tableView.indexPathForSelectedRow?.row
            let favoritePost: PFObject = self.parseData.objectAtIndex(selectedRow!) as! PFObject
            
            let nav = segue.destinationViewController as! UINavigationController
            let viewController = nav.viewControllers[0] as! PostDetailViewController
            
            viewController.postTitle = favoritePost["postTitle"]!.objectAtIndex(0) as! String
            viewController.postDate = favoritePost["postDate"]!.objectAtIndex(0) as! String
            viewController.postDesc = favoritePost["postDesc"]!.objectAtIndex(0) as! String
            viewController.postLink = favoritePost["postLink"]!.objectAtIndex(0) as! String
        }
        
        
        /*
        if segue.identifier == "viewfavorite" {
        let selectedRow = self.tableView.indexPathForSelectedRow?.row
        let favoritePost: PFObject = self.parseData.objectAtIndex(selectedRow!) as! PFObject
        
        let nav = segue.destinationViewController as! UINavigationController
        let viewController = nav.viewControllers[0] as! PostDetailViewController
        
        viewController.postTitle = favoritePost["postTitle"]!.objectAtIndex(0) as! String
        viewController.postDate = favoritePost["postDate"]!.objectAtIndex(0) as! String
        viewController.postDesc = favoritePost["postDesc"]!.objectAtIndex(0) as! String
        viewController.postLink = favoritePost["postLink"]!.objectAtIndex(0) as! String
        }
        */
    }
    
    // MARK: - UISplitViewControllerDelegate
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
}
