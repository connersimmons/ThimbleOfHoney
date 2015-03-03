//
//  PostViewController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 2/24/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextViewDelegate {
    
    /*
    @IBOutlet var webView: UIWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var postDesc: String = String()
    */
    
    @IBOutlet weak var textView: UITextView!
    var postDesc: String = String()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let url: NSURL = NSURL(string: postLink)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        webView.loadRequest(request)
        webView.delegate = self
        */
        
        textView.text = postDesc.html2String
    }
    
    /*
    func webViewDidStartLoad(webView: UIWebView!)  {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView!)  {
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
