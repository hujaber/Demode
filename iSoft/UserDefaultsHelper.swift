//
//  UserDefaultsHelper.swift
//  iSoft
//
//  Created by Hussein Jaber on 2/2/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit

class UserDefaultsHelper: NSObject {
    private static let basketKey = "basketArray"
    private static let wishListKey = "wishListArray"
    private static var basketArray =  Array<Product>()
    private static var wishListArray = Array<Product>()
    
     class func saveProductsToBasket(product: Product) -> (Bool,String?) {
        if isKeyPresentInUserDefaults(key: "basketArray") {
            let basketData = UserDefaults.standard.object(forKey: basketKey)
            basketArray = NSKeyedUnarchiver.unarchiveObject(with: basketData as! Data) as! Array<Product>
        } else {
            let basketData = NSKeyedArchiver.archivedData(withRootObject: basketArray)
            UserDefaults.standard.set(basketData, forKey: basketKey)
        }
        
        for myMroduct in basketArray {
            if myMroduct.id! == product.id! {
                return (false, "This item is already added to basket.")
            }
        }
        product.quantity = "1"
        basketArray.append(product)
        let basketData = NSKeyedArchiver.archivedData(withRootObject: basketArray)
        UserDefaults.standard.set(basketData, forKey: basketKey)
        
        return (true, nil)
    }
    
    
    class func saveProductToWishList(product: Product) -> (Bool, String?) {
        if isKeyPresentInUserDefaults(key: wishListKey) {
            let wishListData = UserDefaults.standard.object(forKey: wishListKey)
            wishListArray = NSKeyedUnarchiver.unarchiveObject(with: wishListData as! Data) as! Array<Product>
        } else {
            let wishListData = NSKeyedArchiver.archivedData(withRootObject: wishListArray)
            UserDefaults.standard.set(wishListData, forKey: wishListKey)
        }
        
        for myProduct in wishListArray {
            if myProduct.id! == product.id! {
                return (false, "This item is already in your wishlist")
            }
        }
        wishListArray.append(product)
        let wishListData = NSKeyedArchiver.archivedData(withRootObject: wishListArray)
        UserDefaults.standard.set(wishListData, forKey: wishListKey)
        return (true, nil)
    }
    
    class func getBasketProducts() -> Array<Product>? {
        if isKeyPresentInUserDefaults(key: basketKey) {
            let basketData =  UserDefaults.standard.object(forKey: basketKey)
            return NSKeyedUnarchiver.unarchiveObject(with: basketData as! Data) as! Array<Product>?
        } else {
            return nil
        }
    }
    
    class func getWishlistProducts() -> Array<Product>? {
        if isKeyPresentInUserDefaults(key: wishListKey) {
            let wishData = UserDefaults.standard.object(forKey: wishListKey)
            return NSKeyedUnarchiver.unarchiveObject(with: wishData as! Data) as! Array<Product>?
        } else {
            return nil
        }
    }
    
    class func updateProductInBasket(product: Product, quantity: String) {
        if isKeyPresentInUserDefaults(key: basketKey) {
            if let myBasketArray = getBasketProducts() {
                for myProd in myBasketArray {
                    if myProd.id! == product.id! {
                        myProd.quantity = quantity
                    }
                }
                let basketData = NSKeyedArchiver.archivedData(withRootObject: myBasketArray)
                UserDefaults.standard.set(basketData, forKey: basketKey)
            }
        }
    }

    
    
    private class func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
}