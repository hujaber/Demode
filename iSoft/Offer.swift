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
    var id: String?
    var desription: String?
    var originalPrice: String?
    var totalPrice: String?
    var discountRate: String?
    var mainImage: String?
    
    static let diskConfig = DiskConfig(
        // The name of disk storage, this will be used as folder name within directory
        name: "Offers",
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

    init(withDictionary jsonDictionary: Dictionary<String, AnyObject>) {
        self.id = jsonDictionary["OfferID"] as? String
        self.desription = jsonDictionary["OfferDesc"] as? String
        self.originalPrice = jsonDictionary["OfferOriginalPrice"] as? String
        self.totalPrice = jsonDictionary["OfferTotalPrice"] as? String
        self.discountRate = jsonDictionary["DiscountRate"] as? String
        self.mainImage = jsonDictionary["MainImage"] as? String
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
        hybrid?.async.setObject(data, forKey: "offerData", completion: {_ in })

    }
    
    static func getOffers(withClosure completionClusore: @escaping (Array<Offer>) ->()) {
        hybrid?.async.object(ofType: Data.self, forKey: "offerData", completion: { (result) in
            DispatchQueue.main.async {
                switch result {
                case .value(let data):
                    let array: [Offer] = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Offer]
                    completionClusore(array)
                case .error(let error):
                    print(error)
                }
            }
        })
    }
    
    
}
