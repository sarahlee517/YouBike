//
//  UIFont+YBKAdditions.swift
//
//  Generated by Zeplin on 4/26/16.
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved. 
//

import UIKit

extension UIFont {
	class func ybkTextStyleFont(size : CGFloat) -> UIFont? {
		return UIFont(name: "Helvetica-Bold", size: size)
	}

    class func ybkTextStyle2Font(size : CGFloat) -> UIFont? {
		return UIFont(name: "PingFangTC-Medium", size: size)
	}
    
    class func ybkTextStyle3Font(size : CGFloat) -> UIFont? {
        return UIFont(name: "PingFangTC-Regular", size: size)
    }
    
    class func ybkTextStyle4Font(size : CGFloat) -> UIFont? {
        return UIFont(name: "PingFangTC-Semibold", size: size)
    }
    
    class func ybkTextStyleHelvetica(size : CGFloat) -> UIFont? {
        return UIFont(name: "Helvetica", size: size)
    }
    
}
