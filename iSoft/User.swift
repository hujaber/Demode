//
//  User.swift
//  iSoft
//
//  Created by Hussein Jaber on 19/4/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {
    var email: String!
    var mobileId: String?
    var name: String!
    var phone: String?
    var verified: Bool!
    
    override init() {
        super.init()
    }
    
    init(jsonDictionary: Dictionary<String, AnyObject>) {
        email = jsonDictionary["email"] as! String!
        mobileId = jsonDictionary["mobileID"] as? String
        name = jsonDictionary["name"] as! String!
        phone = jsonDictionary["phone"] as! String?
        let ver = jsonDictionary["verified"] as! String
        verified = (Int(ver) == 1) ? true : false
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(email, forKey:"email")
        aCoder.encode(mobileId, forKey: "mobileID")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(verified, forKey: "verified")
    }
    
    required init?(coder aDecoder: NSCoder) {
        email = aDecoder.decodeObject(forKey: "email") as! String
        mobileId = aDecoder.decodeObject(forKey: "mobileID") as? String
        name = aDecoder.decodeObject(forKey: "name") as! String!
        phone = aDecoder.decodeObject(forKey: "phone") as? String
        verified = aDecoder.decodeObject(forKey: "verified") as! Bool
    }
    
    static func saveUser(user: User) {
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(data, forKey: "user")
    }
    
    static func getCurrentUser() -> User? {
        let userData = UserDefaults.standard.object(forKey: "user") as? Data
        if (userData != nil) {
            let user = NSKeyedUnarchiver.unarchiveObject(with: userData!) as! User?
            return user
        }
        
        return nil
        
    }
    
}
