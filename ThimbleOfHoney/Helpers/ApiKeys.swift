//
//  ApiKeys.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 3/10/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import Foundation

func valueForAPIKey(#keyname:String) -> String {
    let filePath = NSBundle.mainBundle().pathForResource("ApiKeys", ofType:"plist")
    let plist = NSDictionary(contentsOfFile:filePath!)
    
    let value:String = plist?.objectForKey(keyname) as! String
    return value
}