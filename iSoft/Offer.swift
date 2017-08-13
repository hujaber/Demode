//
//  Offer.swift
//  iSoft
//
//  Created by Hussein Jaber on 25/9/16.
//  Copyright © 2016 Hussein Jaber. All rights reserved.
//

import UIKit
import Cache

class Offer: NSObject, NSCoding {
    var id: String!
    var desription: String!
    var originalPrice: String!
    var totalPrice: String!
    var discountRate: String!
    var mainImage: String?
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
    static let hybrid = HybridCache(name: "offers", config: config)

    init(withDictionary jsonDictionary: Dictionary<String, AnyObject>) {
        self.id = jsonDictionary["OfferID"] as! String!
        self.desription = jsonDictionary["OfferDesc"] as! String!
        self.originalPrice = jsonDictionary["OfferOriginalPrice"] as! String!
        self.totalPrice = jsonDictionary["OfferTotalPrice"] as! String!
        self.discountRate = jsonDictionary["DiscountRate"] as! String!
        self.mainImage = jsonDictionary["MainImage"] as! String?
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(desription, forKey: "description")
        aCoder.encode(originalPrice, forKey: "originalPrice")
        aCoder.encode(totalPrice, forKey: "totalPrice")
        aCoder.encode(discountRate, forKey: "discountRate")
        aCoder.encode(mainImage, forKey: "mainImage")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String!
        self.desription = aDecoder.decodeObject(forKey: "description") as! String!
        self.originalPrice = aDecoder.decodeObject(forKey: "originalPrice") as! String!
        self.totalPrice = aDecoder.decodeObject(forKey: "totalPrice") as! String!
        self.discountRate = aDecoder.decodeObject(forKey: "discountRate") as! String!
        self.mainImage = aDecoder.decodeObject(forKey: "mainImage") as! String?
    }
    
    static func saveOffers(offers: Array<Offer>) {
        let data = NSKeyedArchiver.archivedData(withRootObject: offers)
        do {
            try hybrid.addObject(data, forKey: "offerData")
        } catch let error as Error {
            print(error.localizedDescription)
        }
    }
    
    static func getOffers(withClosure completionClusore: @escaping (Array<Offer>) ->()) {
        hybrid.async.object(forKey: "offerData") { (data: Data?) in
            DispatchQueue.main.async {
                if data != nil {
                    let array: Array<Offer> = NSKeyedUnarchiver.unarchiveObject(with: data!) as! Array<Offer>
                    completionClusore(array)
                } else {
                    completionClusore([])
                }
            }
            
        }
    }
    
    
}
