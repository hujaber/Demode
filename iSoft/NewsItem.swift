//
//  NewsItem.swift
//  iSoft
//
//  Created by Hussein Jaber on 22/4/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import Foundation
import UIKit


struct NewsItem {
    var itemId: String?
    var title: String?
    var detailsText: String?
    var tagImageURL: String?
    var mainImageURL: String?
    
    init(jsonDictionary: Dictionary<String, AnyObject>) {
        itemId = jsonDictionary["NewsID"] as? String
        title  = jsonDictionary["Title"] as? String
        detailsText = jsonDictionary["NText"] as? String
        tagImageURL = jsonDictionary["TagImage"] as? String
        mainImageURL = jsonDictionary["MainImage"] as? String
    }
}
