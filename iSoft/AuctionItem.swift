//
//  AuctionItem.swift
//  iSoft
//
//  Created by Hussein Jaber on 25/4/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import Foundation
/*
 "AuctionID": "1",
 "AuctionTitle": "Live Auction",
 "AuctionDescription": "Our live Auction, Happening now at ASSAHA Hotel, a great collection of glass, furniture, paintings and more..",
 "LotsCount": "20",
 "MainImage": "/webAPI/ImgDir/DemodeAppDB/maincategories/3.jpg",
 "StartAuctionDate": "1483228800",
 "EndAuctionDate": "1514764800",
 "Location": "ASSAHA Main Hall",
 "Status": "1",
 "isOnlineAuction": "0",
 "StatusID": "1",
 "StatusName": "Live",
 "CanUserBid": "1",
 "CanuserViewLots": "1"
 
 */

struct AuctionItem {
    var itemId: String?
    var itemTitle: String?
    var itemDescription: String?
    var lotsCount: String?
    var mainImageURL: String?
    var startAuctionDate: String?
    var endAuctionDate: String?
    var location: String?
    var status: String?
    var isOnlineAuction: Bool
    var statusId: String?
    var statusName: String?
    var userCanBid: Bool
    var userCanViewLots: Bool
    
    init(jsonDictionary: Dictionary<String, AnyObject>) {
        itemId = jsonDictionary["AuctionID"] as? String
        itemTitle = jsonDictionary["AuctionTitle"] as? String
        itemDescription = jsonDictionary["AuctionDescription"] as? String
        lotsCount = jsonDictionary["LotsCount"] as? String
        mainImageURL = jsonDictionary["MainImage"] as? String
        startAuctionDate = jsonDictionary["StartAuctionDate"] as? String
        endAuctionDate = jsonDictionary["EndAuctionDate"] as? String
        location = jsonDictionary["Location"] as? String
        status = jsonDictionary["Status"] as? String
        let online = jsonDictionary["isOnlineAuction"] as? String
        //let ver = jsonDictionary["verified"] as! String
        isOnlineAuction = (Int(online!) == 1) ? true : false
        status = jsonDictionary["StatusID"] as? String
        statusName = jsonDictionary["StatusName"] as? String
        let canBid = jsonDictionary["CanUserBid"] as? String
        userCanBid = (Int(canBid!) == 1) ? true : false
        
        let viewLots = jsonDictionary["CanuserViewLots"] as? String
        userCanViewLots = (Int(viewLots!) == 1) ? true: false
    }
}

struct AuctionDetailsItem {
    /*
     "Product_ID": "29",
     "Product_Code": "PRODUCT_6",
     "Product_Title": "Product5",
     "ShortDescription": "This is the first product",
     "FullDescription": "Full desc for first product",
     "CountryOfOrigin": "Lebanon",
     "ManufactureDate": "2016",
     "Barcode": "ewfewf3355",
     "UOM": null,
     "MainImage": "/webAPI/ImgDir/DemodeAppDB/stock/1.jpg",
     "StartingPrice": "1000",
     "Estimate": "2000",
     "Aqty": "0",
     "LOTID": "6",
     "isSold": "0",
     "SoldFor": "0",
     "isCurrentLot": "0",
     "AuctionID": "1"
 */
    var productID: String?
    var productCode: String?
    var productTitle: String?
    var shortDescription: String?
    var fullDescription: String?
    var originCountry: String?
    var manufactureDate: String?
    var barCode: String?
    var UOM: String?
    var mainImageUrl: String?
    var startingPrice: String?
    var estimate: String?
    var aQty: String?
    var lotID: String?
    var isSold: Bool
    var soldFor: String?
    var isCurrentLot: Bool
    var auctionID: String?
    
    init(jsonDictionary: Dictionary<String, AnyObject>) {
        productID = jsonDictionary["Product_ID"] as? String
        productCode = jsonDictionary["Product_Code"] as? String
        productTitle = jsonDictionary["Product_Title"] as? String
        shortDescription = jsonDictionary["ShortDescription"] as? String
        fullDescription = jsonDictionary["FullDescription"] as? String
        originCountry = jsonDictionary["CountryOfOrigin"] as? String
        manufactureDate = jsonDictionary["ManufactureDate"] as? String
        barCode = jsonDictionary["Barcode"] as? String
        UOM = jsonDictionary["UOM"] as? String
        mainImageUrl = jsonDictionary["MainImage"] as? String
        startingPrice = jsonDictionary["StartingPrice"] as? String
        estimate = jsonDictionary["Estimate"] as? String
        aQty = jsonDictionary["Aqty"] as? String
        lotID = jsonDictionary["LOTID"] as? String
        let sold = jsonDictionary["isSold"] as? String
        isSold = Int(sold!) == 1 ? true: false
        soldFor = jsonDictionary["SoldFor"] as? String
        let currentLot = jsonDictionary["isCurrentLot"] as? String
        isCurrentLot = Int(currentLot!) == 1 ? true: false
        auctionID = jsonDictionary["AuctionID"] as? String
    }
    
    
}
