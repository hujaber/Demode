//
//  Product.swift
//  iSoft
//
//  Created by Hussein Jaber on 8/11/16.
//  Copyright © 2016 Hussein Jaber. All rights reserved.
//

import Foundation

struct ProductKeys {
    static let idKey = "id"
    static let codeKey = "code"
    static let lastCatIdKey = "lastCatIdKey"
    static let parentCatIdKey = "parentCatId"
    static let titleKey = "title"
    static let descriptionKey = "description"
    static let uomKey = "uom"
    static let mainCatIdKey = "mainCat"
    static let priceFontColorKey = "priceFontColor"
    static let priceFontNameKey = "priceFontName"
    static let priceFontSizeKey = "priceFontSize"
    static let salesPriceKey = "salesPrice"
    static let oldPriceKey = "oldPrice"
    static let fontSizeKey = "fontSize"
    static let fontNameKey = "fontName"
    static let fontColorKey = "fontColor"
    static let availableQuantityKey = "availableQuantity"
    static let imageUrlKey = "imageUrl"
}

class Product: NSObject, NSCoding {
    var id: String?
    var code: String?
    var lastCategoryId: String?
    var parentCategoryId: String?
    var title: String?
    var itemDescription: String?
    var uom: String?
    var mainCategoryId: String?
    var priceFontColor: String?
    var priceFontName: String?
    var priceFontSize: String?
    var salesPrice: String?
    var oldPrice: String?
    var fontSize: String?
    var fontName: String?
    var fontColor: String?
    var availableQuantity: String?
    var imageUrl: String?
    var quantity: String?
    var fullDescription: String?
    var thumbImageURL: String?
    
    
    
    init(with jsonDictionary: Dictionary<String, AnyObject>) {
        id                  = jsonDictionary["Product_ID"] as? String
        code                = jsonDictionary["Product_Code"] as? String
        lastCategoryId      = jsonDictionary["LastCategory_ID"] as? String
        parentCategoryId    = jsonDictionary["ParentCategoryID"] as? String
        title               = jsonDictionary["Product_Title"] as? String
        itemDescription     = jsonDictionary["Description"] as? String
        uom                 = jsonDictionary["UOM"] as? String
        mainCategoryId      = jsonDictionary["MainCategoryID"] as? String
        priceFontColor      = jsonDictionary["PriceFontColor"] as? String
        priceFontName       = jsonDictionary["PriceFontName"] as? String
        priceFontSize       = jsonDictionary["PriceFontSize"] as? String
        salesPrice          = jsonDictionary["SalesPrice"] as? String
        oldPrice            = jsonDictionary["OldPrice"] as? String
        fontSize            = jsonDictionary["FontSize"] as? String
        fontName            = jsonDictionary["FontName"] as? String
        fontColor           = jsonDictionary["FontColor"] as? String
        availableQuantity   = jsonDictionary["Aqty"] as? String
        imageUrl            = jsonDictionary["MainImage"] as? String
        fullDescription     = jsonDictionary["FullDescription"] as? String
        thumbImageURL       = jsonDictionary["thumbImage"] as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: ProductKeys.idKey)
        aCoder.encode(code, forKey: ProductKeys.codeKey)
        aCoder.encode(lastCategoryId, forKey: ProductKeys.lastCatIdKey)
        aCoder.encode(parentCategoryId, forKey: ProductKeys.parentCatIdKey)
        aCoder.encode(title, forKey: ProductKeys.titleKey)
        aCoder.encode(itemDescription, forKey: ProductKeys.descriptionKey)
        aCoder.encode(uom, forKey: ProductKeys.uomKey)
        aCoder.encode(mainCategoryId, forKey: ProductKeys.mainCatIdKey)
        aCoder.encode(priceFontColor, forKey: ProductKeys.priceFontColorKey)
        aCoder.encode(priceFontName, forKey: ProductKeys.priceFontNameKey)
        aCoder.encode(priceFontSize, forKey: ProductKeys.priceFontSizeKey)
        aCoder.encode(salesPrice, forKey: ProductKeys.salesPriceKey)
        aCoder.encode(oldPrice, forKey: ProductKeys.oldPriceKey)
        aCoder.encode(fontSize, forKey: ProductKeys.fontSizeKey)
        aCoder.encode(fontName, forKey: ProductKeys.fontNameKey)
        aCoder.encode(fontColor, forKey: ProductKeys.fontColorKey)
        aCoder.encode(availableQuantity, forKey: ProductKeys.availableQuantityKey)
        aCoder.encode(imageUrl, forKey: ProductKeys.imageUrlKey)
        aCoder.encode(quantity, forKey: "quantity")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: ProductKeys.idKey) as! String?
        code = aDecoder.decodeObject(forKey: ProductKeys.codeKey) as! String?
        lastCategoryId = aDecoder.decodeObject(forKey: ProductKeys.lastCatIdKey) as! String?
        parentCategoryId = aDecoder.decodeObject(forKey: ProductKeys.parentCatIdKey) as! String?
        title = aDecoder.decodeObject(forKey: ProductKeys.titleKey) as! String?
        itemDescription = aDecoder.decodeObject(forKey: ProductKeys.descriptionKey) as! String?
        uom = aDecoder.decodeObject(forKey: ProductKeys.uomKey) as! String?
        mainCategoryId = aDecoder.decodeObject(forKey: ProductKeys.mainCatIdKey) as! String?
        priceFontSize = aDecoder.decodeObject(forKey: ProductKeys.priceFontSizeKey) as! String?
        priceFontName = aDecoder.decodeObject(forKey: ProductKeys.priceFontNameKey) as! String?
        priceFontColor = aDecoder.decodeObject(forKey: ProductKeys.priceFontColorKey) as! String?
        salesPrice = aDecoder.decodeObject(forKey: ProductKeys.salesPriceKey) as! String?
        oldPrice = aDecoder.decodeObject(forKey: ProductKeys.oldPriceKey) as! String?
        fontSize = aDecoder.decodeObject(forKey: ProductKeys.fontSizeKey) as! String?
        fontName = aDecoder.decodeObject(forKey: ProductKeys.fontNameKey) as! String?
        fontColor = aDecoder.decodeObject(forKey: ProductKeys.fontColorKey) as! String?
        availableQuantity = aDecoder.decodeObject(forKey: ProductKeys.availableQuantityKey) as! String?
        imageUrl = aDecoder.decodeObject(forKey: ProductKeys.imageUrlKey) as! String?
        quantity = aDecoder.decodeObject(forKey: "quantity") as! String?
        
    }
    

}
