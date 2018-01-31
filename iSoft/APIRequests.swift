//
//  APIRequests.swift
//  iSoft
//
//  Created by Hussein Jaber on 24/9/16.
//  Copyright © 2016 Hussein Jaber. All rights reserved.
//

import UIKit
import Alamofire

class APIRequests: NSObject {
    //Public Variables
    static let baseURL  = "http://www.demode-lb.net/webAPI"
    static let myBaseURL = "http://www.demode-lb.net/iOSAPI"
    
    static let username = "AntiqueApp"
    static let password = "v907.admin"
    static let dbName   = "DemodeAppDB"
    static var parameters: Parameters = [
        "username": username,
        "password": password,
        "dbname"  : dbName
    ]
    static let successKey = "success"
    
    class func fetchOffers(withBlock successBlock: @escaping (Array<Offer> ,Bool, Error?) ->()) {

        let urlString = myBaseURL.appending(APIUrl.offersURL)
        
        Alamofire.request(urlString, method: .get, parameters: parameters).responseJSON { (response) in
            //validate the response
            if let JSON = response.result.value as! [String: AnyObject]!{
                if JSON[successKey] != nil {
                    let success = JSON[successKey] as! String
                    if success == "1" {
                        let offersArray = JSON["offers"] as! Array<AnyObject>
                        var resultArray: Array<Offer>?
                        for offer in offersArray {
                            let newOffer = Offer.init(withDictionary: offer["offer"] as! Dictionary<String, AnyObject>)
                            if resultArray != nil {
                                resultArray?.append(newOffer)
                            } else {
                                resultArray = [newOffer]
                            }
                        }
                        if resultArray != nil{
                            Offer.saveOffers(offers: resultArray!)
                            successBlock(resultArray!, true, nil)
                        } else {
                            successBlock([], true, nil)
                        }
                    } else {
                        successBlock([], false, response.result.error);
                    }
                }
            }
        }
    }
    
    class func fetchMainCategories(withClosure completionClusore: @escaping (Array<Category>, Bool, Error?) ->()) {
        let urlString = myBaseURL.appending(APIUrl.mainCategoryURL)
        
        Alamofire.request(urlString, method: .get, parameters: parameters).responseJSON { (response) in
            if let JSON = response.result.value as! [String: AnyObject]! {
                if JSON[successKey] != nil {
                    let success = JSON[successKey] as! String
                    if success == "1" {
                        let categoriesArray = JSON["MainCategories"] as! Array<AnyObject>
                        var resultsArray: Array<Category>?
                        for category in categoriesArray {
                            let newCategory = Category.init(jsonDictionary: category["category"] as! Dictionary<String, AnyObject>)
                            if resultsArray != nil {
                                resultsArray?.append(newCategory)
                            } else {
                                resultsArray = [newCategory]
                            }
                        }
                        if resultsArray != nil {
                            Category.saveCategories(categories: resultsArray!)
                            completionClusore(resultsArray!, true, nil)
                        } else {
                            completionClusore([], true, nil)
                        }
                    } else {
                        completionClusore([],false, response.result.error)
                    }
                }
            } else {
                completionClusore([], false, response.result.error)
            }
        }
    }

    class func getProducts(withLid Lid: String, Pid: String, completionClosure: @escaping (Bool, Error?, Array<Product>) ->()) {
        let urlString = myBaseURL.appending(APIUrl.productURL);
        var params = parameters
        params["Pid"] = Pid
        params["Lid"] = Lid
        Alamofire.request(urlString, method: .get, parameters: params).responseJSON { (response) in
            if let JSON = response.result.value as! [String: AnyObject]! {
                if JSON[successKey] != nil {
                    let success = JSON[successKey] as! String
                    if success == "1" {
                        let productsArray = JSON["AllProducts"] as! Array<AnyObject>
                        var resultsArray: Array<Product>?
                        for product in productsArray {
                            let newProduct = Product.init(with: product["Product"] as! Dictionary<String, AnyObject>)
                            if resultsArray != nil {
                                resultsArray?.append(newProduct)
                            } else {
                                resultsArray = [newProduct]
                            }
                        }
                        if resultsArray != nil {
                            completionClosure(true, nil, resultsArray!)
                        } else {
                            completionClosure(true, nil, [])
                        }
                        
                    } else {
                        completionClosure(false, response.result.error, [])
                    }
                }
            }
        }
    }
    
    class func getProductImages(withProductId productId: String, completionClosure: @escaping (Bool, Error?, Array<ProductImages>)->()) {
        let urlString = myBaseURL.appending(APIUrl.productImagesURL)
        var params = parameters
        params["pCode"] = productId
        Alamofire.request(urlString, method: .get, parameters: params).responseJSON { (response) in
            if let JSON = response.result.value as! [String: AnyObject]! {
                if JSON[successKey] != nil {
                    let success = JSON[successKey] as! String
                    if success == "1" {
                        let imageArray = JSON["AllImages"] as! Array<AnyObject>
                        var resultsArray: Array<ProductImages>?
                        for image in imageArray {
                            let newImage = ProductImages.init(withJson: image["Image"] as! Dictionary<String, AnyObject>)
                            if resultsArray != nil {
                                resultsArray?.append(newImage)
                            } else {
                                resultsArray = [newImage]
                            }
                        }
                        if resultsArray != nil {
                            completionClosure(true, nil, resultsArray!)
                        } else {
                            completionClosure(true, nil, [])
                        }
                    } else {
                        completionClosure(false, response.result.error, [])
                    }
                }
            }
        }
    }
    
    class func search(forKey key: String, completionCloser: @escaping (Bool, Error?) ->()) {
        let urlString = baseURL.appending(APIUrl.mainSearchURL)
        //ADD key to parameters
        Alamofire.request(urlString, method: .get, parameters: parameters).responseJSON { (response) in
            
        }
    }
    
    class func getRequest(urlString url: String, parameters: Parameters, method: HTTPMethod = .get, completion: @escaping (Bool, Error?, String?, DataResponse<Any>?) ->()) {
        Alamofire.request(url, method: method, parameters: parameters).responseJSON { (jsonResponse) in
            print(jsonResponse)
            if let JSON = jsonResponse.result.value as! [String: AnyObject]! {
                print(JSON)
                if let error = JSON["error"] as? Bool {
                    if error {
                        completion(false, jsonResponse.result.error,JSON["error_msg"] as? String, nil)
                    } else {
                        completion(true, nil, nil, jsonResponse)
                    }
                    
                } else { completion(false, nil, nil, nil) }
            }
        }
    }
    
    static func postRequest(urlString url: String, parameters: Parameters?, method: HTTPMethod = .post, headers: HTTPHeaders?, completion: @escaping (Bool, Error?, String?, DataResponse<Any>?) -> ()) {

        
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            print(response)
            if let JSON = response.result.value as? [String : Any] {
                let success = JSON["success"] as! String
                if success == "1" {
                    completion(true, nil, nil, response)
                } else {
                    completion(false, nil, nil, nil)
                }
            }
        }
    }
    
    class func login(with username: String, password: String, completion: @escaping (Bool, Error?, String?, User?) -> ()) {
        getRequest(urlString: myBaseURL.appending(APIUrl.loginURL), parameters: ["email": username, "password": password], method: .post) { (success, error, errorMessage, response) in
            if (!success) {
                completion(false, error, errorMessage, nil)
            } else {
                if let JSON = response?.result.value as! [String: AnyObject]! {
                    let userDict = JSON["user"] as! Dictionary<String, AnyObject>
                    let user = User.init(jsonDictionary: userDict)
                    User.saveUser(user: user)
                    completion(true, nil, nil, user)
                } else {
                    completion(false, nil, nil, nil)
                }
            }
        }
    }
    
    class func register(fullname: String, email: String, phoneNumber: String, password: String, randomCode: String, completion: @escaping (Bool, Error?, String?) -> ()) {
        let parameters: Parameters = [
            "fname": fullname,
            "password": password,
            "email"  : email,
            "phone"  : phoneNumber,
            "random" : randomCode
        ]
        getRequest(urlString: myBaseURL.appending(APIUrl.registerURL), parameters: parameters, method: .post) { (success, error, errorMessage, response) in
            if (success) {
                if let JSON = response?.result.value as? [String : Any] {
                    let userDictionary = JSON["user"] as? [String : Any]
                    if let userDic = userDictionary {
                        let user = User(jsonDictionary: userDic as Dictionary<String, AnyObject>)
                        User.saveUser(user: user)
                        completion(true, nil, nil)
                    }
                } else {
                    completion(false, nil, nil)
                }
            } else {
                completion(false, error, errorMessage)
            }
        }
    }
    
    class func getNews(completion: @escaping (Bool, Error?, String?, Array<NewsItem>?) ->()) {
        Alamofire.request(myBaseURL.appending(APIUrl.newsURL), method: .get, parameters: parameters).responseJSON { (response) in
            
            if let JSON = response.result.value as! [String: AnyObject]! {
                var resultsArray = Array<NewsItem>()
                if JSON[successKey] != nil {
                    let success = JSON[successKey] as! String
                    if success == "1" {
                        let newsArray = JSON["results"] as! Array<AnyObject>
                        for newsDict in newsArray {
                            let newsItem = NewsItem.init(jsonDictionary: newsDict as! Dictionary<String, AnyObject>)
                            resultsArray.append(newsItem)
                        }
                        completion(true, nil, nil, resultsArray)
                        
                    } else {
                        completion(false, response.result.error, nil, nil)
                    }
                }
            } else {
                completion(false, response.result.error, nil, nil)
            }
        }
    }
    
    class func getAuctions(completion: @escaping (Bool, Error?, String?, Array<AuctionItem>?) -> ()) {
        Alamofire.request(myBaseURL.appending(APIUrl.auctionURL), method: .get, parameters: parameters).responseJSON { (response) in
            if let JSON = response.result.value as! [String: AnyObject]! {
                var resultsArray = Array<AuctionItem>()
                if JSON[successKey] != nil {
                    let success = JSON[successKey] as! String
                    if success == "1" {
                        let auctionsArray = JSON["results"] as! Array<[String: AnyObject]>
                        for auctionsDict in auctionsArray {
                            let auctionItem = AuctionItem.init(jsonDictionary: auctionsDict)
                            resultsArray.append(auctionItem)
                        }
                        completion(true, nil, nil, resultsArray)
                    } else {
                        completion(false, response.result.error, JSON["message"] as? String, nil)
                    }
                }
            }
        }
    }
    
    class func getAuctionDetail(auctionId: String, completion: @escaping (Bool, Error?, String?, Array<AuctionDetailsItem>?) ->()) {
        var params = parameters
        params["auctionID"] = auctionId
        Alamofire.request(myBaseURL.appending(APIUrl.auctionDetailsURL), method: .get, parameters: params).responseJSON { (response) in
            if let JSON = response.result.value as! [String: AnyObject]! {
                var resultsArray = Array<AuctionDetailsItem>()
                if JSON[successKey] != nil {
                    let success = JSON[successKey] as! String
                    if success == "1" {
                        let auctionsDetailsArray = JSON["results"] as! Array<[String: AnyObject]>
                        for itemDict in auctionsDetailsArray {
                            let auctionDetailsItem = AuctionDetailsItem.init(jsonDictionary: itemDict)
                            resultsArray.append(auctionDetailsItem)
                        }
                        completion(true, nil, nil, resultsArray)
                    } else {
                        completion(false, response.result.error, JSON["message"] as? String, nil)
                    }
                }
            }
        }
    }
    
    static func verifyEmail(email: String, completion: @escaping (Bool, Error?, String?) -> ()) {
        var params = parameters
        params["email"] = email
        let urlString = myBaseURL
        getRequest(urlString: urlString.appending(APIUrl.verifyURL), parameters: params, method: .get) { (success, error, errorMessage, response) in
            completion(success, error, nil)
        }
    }
    
    static func addOrder(params: [String : Any], completion: @escaping (Bool, Error?, String?) -> ()) {
        var paramz = parameters
        paramz.merge(dict: params)
        let urlString = myBaseURL.appending(APIUrl.addOrder)
        postRequest(urlString: urlString, parameters: paramz, headers: nil) { (success, error, errorMessage, response) in
            if success {
                if let json = response?.result.value as? [String : Any] {
                    completion(true, nil, (json["orderId"] as! Int).toString())
                } else {
                    completion(false, nil, nil)
                }
            } else {
                completion(false, nil, nil)
            }
        }
    }
    
    static func uploadItems(orderId: String, orderArray: [[String: Any]], completion: @escaping (Bool, Error?, String?) -> ()) {
        var params = parameters
        params["order_id"] = orderId
        params["order_jsn"] = orderArray
        let urlString = myBaseURL.appending(APIUrl.uploadItems)
        postRequest(urlString: urlString, parameters: params, headers: nil) { (success, error, errorString, response) in
            if success {
                if let JSON = response?.result.value as? [String : Any] {
                    if JSON["success"] as? String == "1" {
                        completion(true, nil, nil)
                    } else {
                        completion(false, nil, nil)
                    }
                } else {
                    completion(false, nil, nil)
                }
            }
        }
    }
}

