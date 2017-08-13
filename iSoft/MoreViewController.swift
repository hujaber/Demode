//
//  MoreViewController.swift
//  iSoft
//
//  Created by Hussein Jaber on 2/5/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit

class MoreViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let tableValues = ["Shopping Bag", "Wishlist", "Find a Store", "About us", "Logout"]
    let cellId = "MoreCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        title = "More"

    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        cell?.textLabel?.text = tableValues[indexPath.row]
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        case 0:
            let selectedViewController = storyboard?.instantiateViewController(withIdentifier: "BasketView") as! BasketViewController
            navigationController?.pushViewController(selectedViewController, animated: true)
        case 1:
            let selectedViewController = storyboard?.instantiateViewController(withIdentifier: "WishListView") as! UINavigationController
            navigationController?.pushViewController(selectedViewController.topViewController!, animated: true)
        case 2:
            let selectedViewController = storyboard?.instantiateViewController(withIdentifier: "FindStoreView") as! UINavigationController
            navigationController?.pushViewController(selectedViewController.topViewController!, animated: true)
        case 3:
            let selectedViewController = storyboard?.instantiateViewController(withIdentifier: "AboutView") as! UINavigationController
            navigationController?.pushViewController(selectedViewController.topViewController!, animated: true)
        case 4:
            let loginScreen = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UINavigationController
            let appDelegate = getAppDelegate()
            appDelegate.window?.rootViewController = loginScreen
            UserDefaultsHelper.removeAllKeys()
            
        default:
            print("OK")
        }

        
    }
    
}