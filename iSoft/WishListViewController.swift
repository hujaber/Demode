//
//  WishListViewController.swift
//  iSoft
//
//  Created by Hussein Jaber on 9/10/16.
//  Copyright © 2016 Hussein Jaber. All rights reserved.
//

import UIKit

class WishListViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Wishlist"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    @IBAction func menuButtonPressed(_ sender: AnyObject) {
        openDrawer()
    }
}

extension WishListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = UserDefaultsHelper.getWishlistProducts()?.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketCell") as! BasketCell
        let product = UserDefaultsHelper.getWishlistProducts()![indexPath.row]
        cell.setCellWithBasketItem(product: product)
        cell.totalPriceLabel.text = nil
        return cell
    }
}
