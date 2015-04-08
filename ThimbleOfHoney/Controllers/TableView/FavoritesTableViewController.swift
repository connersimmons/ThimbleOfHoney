//
//  FavoritesTableViewController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 4/7/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var parseData: NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuSetup()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadData()
        println(parseData)
    }
    
    func menuSetup() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    func refresh(sender:AnyObject) {
        self.refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl?.endRefreshing()
    }
    
    func loadData() {
        var device: UIDevice = UIDevice.currentDevice()
        var currentDeviceId: NSString = device.identifierForVendor.UUIDString
        
        self.parseData.removeAllObjects()
        
        var query: PFQuery = PFQuery(className:"Favorite")
        query.whereKey("deviceId", equalTo: currentDeviceId)
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects:[AnyObject]!, error: NSError!) -> Void in
            
            if error == nil {
                for object in objects {
                    let post: PFObject = object as PFObject
                    self.parseData.addObject(object)
                }
                
                let array: NSArray = self.parseData.reverseObjectEnumerator().allObjects
                self.parseData = NSMutableArray(array: array)
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell {
        let cell:PostsTableViewCell = tableView!.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath!) as PostsTableViewCell
        let post: PFObject = self.parseData.objectAtIndex(indexPath!.row) as PFObject
        
        var title: AnyObject = post["postTitle"].objectAtIndex(0)
        cell.postLabel.text = title as? String
        
        var image: AnyObject = post["postDesc"].objectAtIndex(0)
        var urlString = (image as String).findFirstImage(image as String)
        ImageLoader.sharedLoader.imageForUrl(urlString, completionHandler:{(image: UIImage?, url: String) in
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
            refreshLabel.textColor = UIColor.blackColor()
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
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewfavorite" {
            let viewController = segue.destinationViewController as PostDetailViewController
            let selectedRow = self.tableView.indexPathForSelectedRow()?.row
            var favoritePost: PFObject = self.parseData.objectAtIndex(selectedRow!) as PFObject
            
            viewController.postTitle = favoritePost["postTitle"].objectAtIndex(0) as String
            viewController.postDate = favoritePost["postDate"].objectAtIndex(0) as String
            viewController.postDesc = favoritePost["postDesc"].objectAtIndex(0) as String
            viewController.postLink = favoritePost["postLink"].objectAtIndex(0) as String
        }
	}
}
