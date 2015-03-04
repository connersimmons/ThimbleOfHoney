//
//  PostViewController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 2/24/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var postDesc: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let url: NSURL = NSURL(string: postLink)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        webView.loadRequest(request)
        webView.delegate = self
        */
        
        //textView.text = postDesc.html2String
        
        webView.loadHTMLString(postDesc, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
