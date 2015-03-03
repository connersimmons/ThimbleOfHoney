//
//  AboutMeViewController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 3/3/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController, XMLParserDelegate {

    @IBOutlet weak var blogContent: UITextView!
    
    var xmlParser: XMLParser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let aboutMeURL = NSURL(string:"http://thimbleofhoney.com/about")
        let htmlString = NSData(contentsOfURL: aboutMeURL!)
        var dataString: NSString = NSString(data: htmlString!, encoding: NSUTF8StringEncoding)!
        
        let aboutMeDesc = findAboutMeContent(dataString)
        println(aboutMeDesc)
        //blogContent.text = aboutMeDesc
        
        
        var attrStr = NSAttributedString(
            data: aboutMeDesc.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil,
            error: nil)

        blogContent.text = attrStr?.string
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func parsingWasFinished() {
        self.reloadInputViews()
    }
    
    func findAboutMeContent(html: NSString) -> NSString {
        let htmlContent = html
        var description = ""
        
        let rangeOfString = NSMakeRange(0, htmlContent.length)
        let regex = NSRegularExpression(pattern: "(<section class=\"content\".*?>)(.*?</div>.*?)(</div>)", options: nil, error: nil)
        
        if htmlContent.length > 0 {
            let match = regex?.firstMatchInString(htmlContent, options: nil, range: rangeOfString)
            
            if match != nil {
                var aboutMeDesc = htmlContent.substringWithRange(match!.rangeAtIndex(2)) as NSString
                description = aboutMeDesc
            }
        }
        return description
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
