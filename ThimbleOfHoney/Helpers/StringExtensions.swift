//
//  StringExtensions.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 4/7/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import Foundation

extension String {
        
    func findFirstImage() -> NSString {
        let htmlContent = self as NSString
        var imageSource = ""
        
        let rangeOfString = NSMakeRange(0, htmlContent.length)
        let regex = try? NSRegularExpression(pattern: "(<img.*?src=\")(.*?)(\".*?>)", options: [])
        
        if htmlContent.length > 0 {
           let match = regex?.firstMatchInString(htmlContent as String, options: [], range: rangeOfString)
                
           if match != nil {
                var imageURL = htmlContent.substringWithRange(match!.rangeAtIndex(2)) as NSString
                imageURL = imageURL.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                imageSource = imageURL as String
           }
        }
        
        return imageSource
    }
    
}