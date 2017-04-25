//
//  ProductImages.swift
//  iSoft
//
//  Created by Hussein Jaber on 9/1/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import Foundation

struct ProductImages {
    var productId: String?
    var imageId: String?
    var imageDescription: String?
    var imageUrl: String?
    
    init(withJson json: Dictionary<String, AnyObject>) {
        productId = json["Product_ID"] as? String
        imageId = json["ImageID"] as? String
        imageDescription = json["ImageDescription"] as? String
        imageUrl = json["MainImage"] as? String
    }
    
}
