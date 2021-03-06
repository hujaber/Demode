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
    static let diskConfig = DiskConfig(
        // The name of disk storage, this will be used as folder name within directory
        name: "Categories",
        // Expiry date that will be applied by default for every added object
        // if it's not overridden in the `setObject(forKey:expiry:)` method
        expiry: .date(Date().addingTimeInterval(2*3600)),
        // Maximum size of the disk cache storage (in bytes)
        maxSize: 10000,
        // Where to store the disk cache. If nil, it is placed in `cachesDirectory` directory.
        directory: try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                appropriateFor: nil, create: true).appendingPathComponent("MyPreferences"),
        // Data protection is used to store files in an encrypted format on disk and to decrypt them on demand
        protectionType: .complete
    )
    static let memoryConfig = MemoryConfig(
        // Expiry date that will be applied by default for every added object
        // if it's not overridden in the `setObject(forKey:expiry:)` method
        expiry: .date(Date().addingTimeInterval(2*60)),
        /// The maximum number of objects in memory the cache should hold
        countLimit: 50,
        /// The maximum total cost that the cache can hold before it starts evicting objects
        totalCostLimit: 0
    )
    
    static let hybrid = try? Storage(diskConfig: diskConfig, memoryConfig: memoryConfig)
    
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
        if let mainImage = self.mainImage {
            self.mainImage = APIUrl.mainURL.appending(mainImage);
        } else {
            self.mainImage = nil
        }
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
        hybrid?.async.setObject(data, forKey: "data", completion: { (result) in

        })
    }
    
    static func getCategories(withClosure completionClusore: @escaping (Array<Category>) ->()) {
        hybrid?.async.object(ofType: Data.self, forKey: "data", completion: { (result) in
            switch result {
            case .value(let data):
                let array: [Category] = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Category]
                completionClusore(array)
            case .error(let error):
                print(error)
            }
        })

    }
}
