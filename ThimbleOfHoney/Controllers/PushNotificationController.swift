//
//  PushNotificationController.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 3/10/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import Foundation

class PushNotificationController: NSObject {
    
    override init() {
        super.init()
        
        let parseApplicationID = valueForAPIKey(keyname: "PARSE_APPLICATION_ID")
        let parseClientKey = valueForAPIKey(keyname: "PARSE_CLIENT_KEY")
        Parse.setApplicationId(parseApplicationID, clientKey: parseClientKey)
        
        /*
        var object = PFObject(className: "testDataClass")
        object.addObject("iOSBlog", forKey: "websiteUrl")
        object.addObject("Five", forKey: "websiteRating")
        object.save()
        */
    }
   
}
