//
//  StringExtensions.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 4/7/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import Foundation

extension String {
        
    func findFirstImage(aString: String) -> NSString {
        let htmlContent = aString as NSString
        //let htmlContect = self
        var imageSource = ""
        
        let rangeOfString = NSMakeRange(0, htmlContent.length)
        let regex = NSRegularExpression(pattern: "(<img.*?src=\")(.*?)(\".*?>)", options: nil, error: nil)
        
        if htmlContent.length > 0 {
           let match = regex?.firstMatchInString(htmlContent, options: nil, range: rangeOfString)
                
           if match != nil {
                var imageURL = htmlContent.substringWithRange(match!.rangeAtIndex(2)) as NSString
                imageURL = imageURL.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                imageSource = imageURL
           }
        }
        return imageSource
    }
    
}