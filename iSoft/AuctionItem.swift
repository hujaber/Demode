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
