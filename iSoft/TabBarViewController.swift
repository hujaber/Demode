//
//  TabBarViewController.swift
//  iSoft
//
//  Created by Hussein Jaber on 26/4/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let auctionView = storyboard?.instantiateViewController(withIdentifier: "AuctionScene") as! UINavigationController
        let storeVC = UIApplication.shared.delegate as! AppDelegate
        let drawerController = storeVC.drawerController
        let newsVC = storyboard?.instantiateViewController(withIdentifier: "NewsView") as! UINavigationController
        let moreVC = storyboard?.instantiateViewController(withIdentifier: "MoreScene") as!
            UINavigationController
        
        viewControllers = [auctionView ,drawerController!, newsVC, moreVC]

        
        (tabBar.items![0] as UITabBarItem).image = #imageLiteral(resourceName: "auction")
        (tabBar.items![0] as UITabBarItem).title = "Auctions"

        
        (tabBar.items![1] as UITabBarItem).image = #imageLiteral(resourceName: "tabStore")
        (tabBar.items![1] as UITabBarItem).title = "Store"
        
        (tabBar.items![2] as UITabBarItem).image = UIImage(named: "news")
        (tabBar.items![2] as UITabBarItem).title = "News"
        
        (tabBar.items![3] as UITabBarItem).image = #imageLiteral(resourceName: "Menu")
        (tabBar.items![3] as UITabBarItem).title = "More"

    }
}
