//
//  SubCategory.swift
//  iSoft
//
//  Created by Hussein Jaber on 16/10/16.
//  Copyright © 2016 Hussein Jaber. All rights reserved.
//

import Foundation
import Cache
/*
 "subCategories": [
 {
 "subCategory": {
 "SubCategoryID": "1",
 "SubCategoryName": "Custom Upholstery",
 "SubCategoryTitle": "Custom Upholstery",
 "MainCategoryID": "1",
 "FontSize": "24",
 "FontName": "a",
 "Fontcolor": "1",
 "isLaterSubCategory": "0"
 */

class SubCategory: NSObject, NSCoding {
    var id: String!
    var title: String?
    var name: String?
    var mainCategoryID: String?
    var fontSize: String?
    var fontName: String?
    var fontColor: String?
    var hasSubCategory: Bool?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(fontColor, forKey: "fontColor")
        aCoder.encode(fontName, forKey: "fontName")
        aCoder.encode(fontSize, forKey: "fontSize")
        aCoder.encode(hasSubCategory, forKey: "hasSubCat")
        aCoder.encode(mainCategoryID, forKey: "mainCatID")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.fontColor = aDecoder.decodeObject(forKey: "fontColor") as? String
        self.fontName = aDecoder.decodeObject(forKey: "fontName") as? String
        self.fontSize = aDecoder.decodeObject(forKey: "fontSize") as? String
        self.hasSubCategory = aDecoder.decodeObject(forKey: "hasSubCat") as? Bool
        self.mainCategoryID = aDecoder.decodeObject(forKey: "mainCatID") as? String
    }
    
    init(jsonDictionary: Dictionary<String, AnyObject>) {
        self.id = jsonDictionary["SubCategoryID"] as! String!
        self.name = jsonDictionary["SubCategoryName"] as? String
        self.title = jsonDictionary["SubCategoryTitle"] as? String
        self.mainCategoryID = jsonDictionary["MainCategoryID"] as! String!
        self.fontSize = jsonDictionary["FontSize"] as? String
        self.fontName = jsonDictionary["FontName"] as? String
        self.fontColor = jsonDictionary["FontColor"] as! String?
        self.hasSubCategory = jsonDictionary["isLaterSubCategory"]?.boolValue
    }
    
    override init() {
        super.init()
    }
}
