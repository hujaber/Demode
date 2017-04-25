//
//  NewsViewController.swift
//  iSoft
//
//  Created by Hussein Jaber on 23/4/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit
import Kingfisher

class NewsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var tableValues = Array<NewsItem>()
    let cellId = "NewsCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        showLoader()
        APIRequests.getNews { (success, error, errorMsg, result) in
            self.hideLoader()
            if success {
                self.tableValues = result!
                self.tableView.reloadData()
            }
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.lightGray.withAlphaComponent(0.7)
    }

    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewsCell
        cell.setCell(newsItem: tableValues[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    let baseUrl = "http://www.demode-lb.net"
    func setCell(newsItem: NewsItem) {
        titleLabel.text = newsItem.title!
        titleLabel.textColor = UIColor.myBlueColor()
        detailsLabel.text = newsItem.detailsText
        detailsLabel.textColor = UIColor.myBlueColor()
        let url = URL(string: baseUrl.appending(newsItem.tagImageURL!))!
        let resource = ImageResource.init(downloadURL: url)
        newsImageView.kf.indicatorType = .activity
        newsImageView.kf.setImage(with: resource, placeholder: nil, options: [], progressBlock: nil, completionHandler: { (image, error, cachetype, url) in
        })
    }
}
