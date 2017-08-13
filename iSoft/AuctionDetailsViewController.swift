//
//  AuctionDetailsViewController.swift
//  iSoft
//
//  Created by Hussein Jaber on 26/4/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit

class AuctionDetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var tableValues = Array<AuctionDetailsItem>()
    public var auctionId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Auction Details"
        setupTableView()
        fetchData()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
    }
    
    func fetchData() {
        showLoader()
        APIRequests.getAuctionDetail(auctionId: auctionId!) { (success, error, errorMsg, results) in
            self.hideLoader()
            if success {
                self.tableValues = results!
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuctionDetailsCell")
        cell?.textLabel?.text = tableValues[indexPath.row].productTitle!
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
