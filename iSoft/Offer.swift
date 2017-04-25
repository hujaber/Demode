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
    static let config = Config(frontKind: .disk, backKind: .disk, expiry: .seconds(180000), maxSize: 1000000, maxObjects: 100000)
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
        hybrid.add("offerData", object: data)
    }
    
    static func getOffers(withClosure completionClusore: @escaping (Array<Offer>) ->()) {
        hybrid.object("offerData") { (data: Data?) in
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
