//
//  LeftTableViewController.swift
//  iSoft
//
//  Created by Hussein Jaber on 9/10/16.
//  Copyright © 2016 Hussein Jaber. All rights reserved.
//

import UIKit


//home, shopping bag, wishlist, find a store, about
class LeftTableViewController: UITableViewController {
    let cellId = "LeftMenuCell"
    var views: [AnyObject]?
    var homeViewController: UINavigationController?
    var shoppingBagView: UINavigationController?
    var wishListView: UINavigationController?
    var findStoreView: UINavigationController?
    var aboutView: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "iSoft"
        setupControllers()
        tableView.tableFooterView = UIView.init()
    }
    
    // MARK: Setups
    
    func setupControllers() {
        views = Array<AnyObject>()
        homeViewController = (self.storyboard?.instantiateViewController(withIdentifier: "StoreView") as! UINavigationController)
        views?.append(homeViewController!)
        shoppingBagView = (self.storyboard?.instantiateViewController(withIdentifier: "ShoppingBagView") as! UINavigationController)
        views?.append(shoppingBagView!)
        wishListView = (self.storyboard?.instantiateViewController(withIdentifier: "WishListView") as! UINavigationController)
        views?.append(wishListView!)
        findStoreView = (self.storyboard?.instantiateViewController(withIdentifier: "FindStoreView") as! UINavigationController)
        views?.append(findStoreView!)
        aboutView = (self.storyboard?.instantiateViewController(withIdentifier: "AboutView") as! UINavigationController)
        views?.append(aboutView!)
    
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = views?.count {
            return count
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Home"
        case 1:
            cell.textLabel?.text = "Shopping Bag"
        case 2:
            cell.textLabel?.text = "Wishlist"
        case 3:
            cell.textLabel?.text = "Find a Store"
        case 4:
            cell.textLabel?.text = "About us"
        default:
            cell.textLabel?.text = ""
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let drawer = appDelegate.drawerController
        drawer?.setCenter(views?[indexPath.row] as! UIViewController, withCloseAnimation: true, completion: nil)
    }
    
}
