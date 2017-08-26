//
//  Category.swift
//  iSoft
//
//  Created by Hussein Jaber on 16/10/16.
//  Copyright © 2016 Hussein Jaber. All rights reserved.

import Foundation
import UIKit
import Cache

class Category: NSObject, NSCoding {
    var id: String!
    var name: String!
    var title: String?
    var fontColor: String?
    var fontName: String?
    var fontSize: Int?
    var mainImage: String?
    var backgroundColor: Int?
    var hasSubCategory: Bool?
    var subCategories: Array<SubCategory>?
    
//    static let config = Config(expiry: .seconds(180000), memoryCountLimit: 100, memoryTotalCostLimit: 1000, maxDiskSize: 3000000, cacheDirectory: )
    static let config = Config(
        // Expiry date that will be applied by default for every added object
        // if it's not overridden in the add(key: object: expiry: completion:) method
        expiry: .date(Date().addingTimeInterval(100000)),
        /// The maximum number of objects in memory the cache should hold
        memoryCountLimit: 0,
        /// The maximum total cost that the cache can hold before it starts evicting objects
        memoryTotalCostLimit: 0,
        /// Maximum size of the disk cache storage (in bytes)
        maxDiskSize: 10000,
        // Where to store the disk cache. If nil, it is placed in an automatically generated directory in Caches
        cacheDirectory: NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                            FileManager.SearchPathDomainMask.userDomainMask,
                                                            true).first! + "/cache-in-documents"
    )
    
    static let hybrid = HybridCache(name: "test", config: config)
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(fontColor, forKey: "fontColor")
        aCoder.encode(fontName, forKey: "fontName")
        aCoder.encode(fontSize, forKey: "fontSize")
        aCoder.encode(mainImage, forKey: "mainImage")
        aCoder.encode(backgroundColor, forKey: "bgColor")
        aCoder.encode(hasSubCategory, forKey: "hasSubCat")
        aCoder.encode(subCategories, forKey: "subCats")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.fontColor = aDecoder.decodeObject(forKey: "fontColor") as? String
        self.fontName = aDecoder.decodeObject(forKey: "fontName") as? String
        self.fontSize = aDecoder.decodeObject(forKey: "fontSize") as? Int
        self.mainImage = aDecoder.decodeObject(forKey: "mainImage") as? String
        self.backgroundColor = aDecoder.decodeObject(forKey: "bgColor") as? Int
        self.hasSubCategory = aDecoder.decodeObject(forKey: "hasSubCat") as? Bool
        self.subCategories = aDecoder.decodeObject(forKey: "subCats") as? Array<SubCategory>
    }
    
    init(jsonDictionary: Dictionary<String, AnyObject>) {
        self.id = jsonDictionary["CategoryID"] as! String
        self.name = jsonDictionary["CategoryName"] as! String
        self.title = jsonDictionary["CategoryTitle"] as? String
        self.fontColor = jsonDictionary["FontColor"] as? String
        self.fontName = jsonDictionary["FontName"] as? String
        self.mainImage = jsonDictionary["MainImage"] as? String
        self.mainImage = APIUrl.mainURL.appending(self.mainImage!);
        self.backgroundColor = jsonDictionary["background"] as? Int
        self.hasSubCategory = jsonDictionary["isLaterSubCategory"]?.boolValue
        var subCategs = [SubCategory]()
        if let subCats = jsonDictionary["subCategories"] as? Array<AnyObject> {
            for sub in subCats {
                let subCategory = SubCategory.init(jsonDictionary: sub["subCategory"] as! Dictionary<String, AnyObject>)
                subCategs.append(subCategory)
            }
        }
        self.subCategories = subCategs
    }

    static func saveCategories(categories: Array<Category>) {
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: categories)
        do {
            try hybrid.addObject(data, forKey: "data")
        } catch let error as Error {
            print(error.localizedDescription)
        }

    }
    
    static func getCategories(withClosure completionClusore: @escaping (Array<Category>) ->()) {
        hybrid.async.object(forKey: "data") { (data: Data?) in
            DispatchQueue.main.async {
                if data != nil {
                    let array: Array<Category> = NSKeyedUnarchiver.unarchiveObject(with: data!) as! Array<Category>
                    completionClusore(array)
                } else {
                    completionClusore([])
                }
            }
        }
    }
}
