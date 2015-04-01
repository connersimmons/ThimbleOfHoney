//
//  CustoColor.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 4/1/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import Foundation

class CustomColor: UIColor {
    var customColor: UIColor!
    
    init(hex: UInt) {
        super.init()
        customColor = UIColorFromRGB(hex)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
