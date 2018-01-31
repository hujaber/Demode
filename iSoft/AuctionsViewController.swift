//
//  AuctionsViewController.swift
//  iSoft
//
//  Created by Hussein Jaber on 25/4/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit
import Kingfisher

class AuctionsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var tableValues = Array<AuctionItem>()
    var selectedItem: AuctionItem?

    override func viewDidLoad() {
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        }
        super.viewDidLoad()
        let view = UIView(frame: self.view.frame)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.text = "Under Construction"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        view.addSubview(label)
        label.center = view.center
        self.view.addSubview(view)
        tableView.isHidden = true

    }
    
    func getAuctions() {
        showLoader()
        APIRequests.getAuctions { (success, error, errorMsg, results) in
            self.hideLoader()
            self.tableValues = results!
            self.tableView.reloadData()
        }
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "auctionCell") as! AuctionCell
        let item = tableValues[indexPath.row]
        cell.setCell(auctionItem: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = tableValues[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "segueToAuctionDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAuctionDetails" {
            let vc = segue.destination as! AuctionDetailsViewController
            vc.auctionId = selectedItem!.itemId!
            
        }
    }
}

class AuctionCell: UITableViewCell {
    let baseUrl = "http://www.demode-lb.net"
    @IBOutlet weak var auctionImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    func setCell(auctionItem: AuctionItem) {
        titleLabel.numberOfLines = 0
        detailsLabel.numberOfLines = 0
        if let title = auctionItem.itemTitle {
            titleLabel.text = title
        }
        if let description = auctionItem.itemDescription {
            detailsLabel.text = description
        }
        if let imageUrl = auctionItem.mainImageURL {
            let url = URL(string:baseUrl.appending(imageUrl))
            let resource = ImageResource.init(downloadURL: url!)
            auctionImageView.kf.indicatorType = .activity
            auctionImageView.kf.setImage(with: resource)
        }
    }
    
    
    
    
}
