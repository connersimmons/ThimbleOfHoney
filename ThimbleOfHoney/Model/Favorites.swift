//
//  Favorites.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 4/5/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit
import CoreData

class Favorites: NSManagedObject {
    
    @NSManaged var postTitle: String
    @NSManaged var postDate: String
    @NSManaged var postDesc: String
    @NSManaged var postLink: String
   
}
