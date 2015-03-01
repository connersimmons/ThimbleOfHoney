//
//  BlogPost.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 2/24/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import Foundation

class BlogPost {
    var postTitle: String = String()
    var postLink: String = String()
    var postDesc: String = String()
    var postThumbnail: UIImage
    
    init() {
        postThumbnail = UIImage(named: "placeholder")!
    }
}