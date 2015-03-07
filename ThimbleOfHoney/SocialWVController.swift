//
//  SocialWVController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 3/7/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit

class SocialWVController: UIViewController, UIWebViewDelegate {
    
    var socialLink: String = String()

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url: NSURL = NSURL(string: socialLink)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        webView.loadRequest(request)
        webView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
