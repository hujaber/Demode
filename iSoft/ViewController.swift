//
//  ViewController.swift
//  iSoft
//
//  Created by Hussein Jaber on 24/9/16.
//  Copyright © 2016 Hussein Jaber. All rights reserved.

import UIKit
import ImageSlideshow
import Kingfisher


class ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var sections = [Section]()
    let cellId = "Cell"
    let segueID = "segueToProducts"
    var tableValues: Array<AnyObject>?
    var expandedSections = Set<Int>()
    var imageSlideValues: Array<Offer>?
    var selectedMainID: String?
    var selectedSubID: String?
    var selectedCategoryName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getOffers()
        getMainCategories()
    }
    
    //MARK: - API Requests
    
    func getMainCategories() {
        showLoader()
        APIRequests.fetchMainCategories { (results, success, error) in
            self.hideLoader()
            if success {
                if results.count > 0 {
                    self.tableValues = results
                } else {
                    self.tableValues = []
                }
                self.setup()
            }
        }
    }
    
    func getOffers() {
        APIRequests.fetchOffers { (results, success, error) in
            if success {
                self.imageSlideValues = results
                self.setupImageSlide()
            }
        }
    }
    
    //MARK: - IBAction
    @IBAction func menuButtonPressed(_ sender: AnyObject) {
        openDrawer()
    }
    
    //MARK: - Setups
    func setup() {
        for category in self.tableValues! {
            sections.append(Section.init(mainCategory: category as! Category))
        }
        self.tableView.reloadData()
    }
    
    func setupImageSlide() {
        let slider = ImageSlideshow.init(frame: CGRect.init(0, 0, tableView.frame.size.width, 200))
        var imageArray = Array<ImageSource>()
        for offer in imageSlideValues! {
            let imageURL = APIUrl.mainURL.appending(offer.mainImage!)
            ImageDownloader.default.downloadImage(with: URL.init(string: imageURL)!, options: [], progressBlock: nil, completionHandler: { (image, error, url, data) in
                if image != nil {
                    imageArray.append(ImageSource(image: image!))
                }
                slider.setImageInputs(imageArray)
            })
        }
        slider.circular = true
        slider.slideshowInterval = 3
        slider.backgroundColor = UIColor.white
        slider.contentScaleMode = .scaleToFill
        self.tableView.tableHeaderView = slider;
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
        tableView.separatorColor = UIColor.clear
    }
    

    
    //MARK: - TableView Delegate & Datasource
    
    func canCollapse(_ tableView: UITableView, canCollapseSection section: Int) -> Bool {
        if section >= 0 {
            return true
        }
        return false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (canCollapse(tableView, canCollapseSection: section)) {
            if (expandedSections.contains(section)) {
                return sections[section].subCategories.count + 1
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MainCategoryCell
        if (canCollapse(tableView, canCollapseSection: indexPath.section)) {
            let item = sections[indexPath.section]
            if indexPath.row == 0 {
                cell.setCell(section: item)
                return cell
            } else {
                let secondCell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
                secondCell.selectionStyle = .default
                secondCell.backgroundColor = UIColor.white
                let subCat = item.subCategories[indexPath.row - 1] as! SubCategory
                if subCat.title != nil {
                    secondCell.textLabel?.text = " " + subCat.title!
                }
                secondCell.accessoryType = .disclosureIndicator
                secondCell.textLabel?.textColor = UIColor.black.withAlphaComponent(0.8)
                secondCell.backgroundView = UIView.init()
                secondCell.preservesSuperviewLayoutMargins = false
                secondCell.separatorInset = UIEdgeInsets.zero
                secondCell.layoutMargins = UIEdgeInsets.zero
                
                
                return secondCell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if canCollapse(tableView, canCollapseSection: indexPath.section) {
            if indexPath.row == 0 {
                tableView.deselectRow(at: indexPath, animated: true)
                let section = indexPath.section
                let currentlyExpanded = expandedSections.contains(section)
                var rows = Int()
                var tmpArray = [IndexPath]()
                if currentlyExpanded {
                    rows = (tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section))!
                    expandedSections.remove(section)
                } else {
                    expandedSections.insert(section)
                    rows = (tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section))!
                }
                
                for i in 1..<rows {
                    let tmpIndexPath = IndexPath(row: i, section: section)
                    tmpArray.append(tmpIndexPath)
                }
                
                if currentlyExpanded {
                    tableView.deleteRows(at: tmpArray, with: .none)
                } else {
                    tableView.insertRows(at: tmpArray, with: .none)
                    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
                print("\(indexPath.section) \(indexPath.row)")
                selectedMainID = sections[indexPath.section].mainCategory.id
                let subCat = sections[indexPath.section].subCategories[indexPath.row - 1] as! SubCategory
                selectedSubID = subCat.id
                selectedCategoryName = subCat.name
                performSegue(withIdentifier: segueID, sender: self)
            }
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID {
            let vc = segue.destination as! ProductsViewController
            vc.mainCatID = selectedMainID!
            vc.subCatID = selectedSubID!
            vc.title = selectedCategoryName!
        }
    }
}

class MainCategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setCell(section: Section) {
        selectionStyle = .none
        titleLabel.text = section.mainCategory.title!
        titleLabel.textColor = UIColor.white
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        titleLabel.alpha = 1.0
        categoryImageView.kf.indicatorType = .activity
        categoryImageView.contentMode = .scaleAspectFill
        let url = URL(string: section.mainCategory.mainImage!)!
        let resource = ImageResource.init(downloadURL: url)
        categoryImageView.kf.setImage(with: resource, placeholder: nil, options: [], progressBlock: nil, completionHandler: { (image, error, cachetype, url) in
        })

    }
    
}

