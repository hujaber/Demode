//
//  Section.swift
//  iSoft
//
//  Created by Hussein Jaber on 16/10/16.
//  Copyright © 2016 Hussein Jaber. All rights reserved.
//

import Foundation
import UIKit

struct Section {
    var mainCategory: Category!
    var subCategories: Array<AnyObject>!
    var collapsed: Bool!
    
    init(mainCategory: Category, collapsed: Bool = true) {
        self.mainCategory = mainCategory
        self.subCategories = mainCategory.subCategories
        self.collapsed = collapsed
    }

}
