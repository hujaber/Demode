//
//  CGRect+Custom.swift
//  iSoft
//
//  Created by Hussein Jaber on 16/10/16.
//  Copyright © 2016 Hussein Jaber. All rights reserved.
//

import Foundation
import UIKit

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}
