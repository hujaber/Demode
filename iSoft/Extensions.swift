//
//  Extensions.swift
//  iSoft
//
//  Created by Hussein Jaber on 4/12/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit

extension UITextField {
    public func addBottomBorder(width: CGFloat = 1.0, color: UIColor = UIColor.myBlueColor()) {
        borderStyle = .none
        self.layer.sublayers?.forEach({ (layer) in
            if layer.value(forKey: "name") != nil {
                layer.removeFromSuperlayer()
            }
        })
        if borderStyle == .none {
            let border = CALayer.init()
            border.setValue("border", forKey: "name")
            border.borderColor = color.cgColor
            border.backgroundColor = color.cgColor
            border.frame = CGRect.init(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
            border.borderWidth = width
            layer.addSublayer(border)
            layer.masksToBounds = true
        }
    }
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
