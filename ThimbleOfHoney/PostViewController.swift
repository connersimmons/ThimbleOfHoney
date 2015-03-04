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
    var postDesc: String = String()
    var postLink: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var cssString = "<style type='text/css'>img { max-width: 100%; width: auto; height: auto; }</style>"
        webView.loadHTMLString(cssString + postDesc, baseURL: nil)
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
