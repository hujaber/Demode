//
//  ProductsViewController.swift
//  iSoft
//
//  Created by Hussein Jaber on 1/11/16.
//  Copyright © 2016 Hussein Jaber. All rights reserved.
//

import UIKit
import Kingfisher
import SKPhotoBrowser
import SVProgressHUD
//Note: Lid: id of the parent item
//Pid: id of parent category

class ProductsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, ProductCellProtocol {
    @IBOutlet var collectionView: UICollectionView!
    var values = Array<Product>()
    var mainCatID: String?
    var subCatID: String?
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearching: Bool = false
    var searchResults = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchBar()
        print("Pid= \(mainCatID!) and Lid= \(subCatID!)")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (screenWidth), height: (screenHeight/2.2))
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        collectionView!.backgroundColor = UIColor.white
        collectionView.bounces = true
        getProducts()
    }
    
    func addSearchBar() {
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.myBlueColor()
        searchController.dimsBackgroundDuringPresentation = false
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.title = "Products"
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
            navigationController?.navigationBar.barTintColor = UIColor.myBlueColor()
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search products", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        } else {
            self.searchController.hidesNavigationBarDuringPresentation = false;
            self.definesPresentationContext = false;
            navigationItem.titleView = searchController.searchBar
            title = "Products"
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search products", attributes: [NSAttributedStringKey.foregroundColor: UIColor.myBlueColor()])
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.myBlueColor()]
        }
        


    }
    
    func getProducts() {
        showLoader()
        APIRequests.getProducts(withLid: subCatID!, Pid: mainCatID!) { (success, error, results) in
            self.hideLoader()
            if success {
                self.values = results
                self.collectionView.reloadData()
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return searchResults.count
        } else {
            return values.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var product: Product!
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCell", for: indexPath) as! ProductsCollectionViewCell
        cell.delegate = self
        if isSearching {
            product = self.searchResults[indexPath.row]
        } else {
            product = self.values[indexPath.row]
        }
        cell.fillCellWithProduct(product: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let product = values[indexPath.row]
        var product: Product!
        if isSearching {
            product = self.searchResults[indexPath.row]
        } else {
            product = self.values[indexPath.row]
        }
        showLoader()
        APIRequests.getProductImages(withProductId: product.id!) { (success, error, images) in
            self.hideLoader()
            var myImages = [SKPhoto]()
            if (product.imageUrl != nil) {
                let photo = SKPhoto.photoWithImageURL(APIUrl.mainURL.appending(product.imageUrl!))
                photo.shouldCachePhotoURLImage = true
                if product.itemDescription != nil {
                    photo.caption = product.itemDescription!
                } else {
                    if let title = product.title, let price = product.salesPrice {
                        photo.caption = title + "\n" + "$" + price
                    }
                }

                myImages.append(photo)
            }

            for prodImage in images {
                if let imageURL = prodImage.imageUrl {
                    let photo = SKPhoto.photoWithImageURL(APIUrl.mainURL.appending(imageURL))
                    photo.shouldCachePhotoURLImage = true
                    if prodImage.imageDescription != nil {
                        photo.caption = prodImage.imageDescription
                    } else {
                        if let title = product.title, let price = product.salesPrice {
                            photo.caption = title + "\n" + "$" + price
                        }
                    }

                    myImages.append(photo)
                }

            }
            SKPhotoBrowserOptions.displayAction = true
            SKPhotoBrowserOptions.bounceAnimation = true
            let browser = SKPhotoBrowser(photos: myImages)
            browser.initializePageIndex(0)
            
            if myImages.count > 0 {
               self.present(browser, animated: true, completion: {})
            }

        }
    }
    
    //MARK: - Cell Delegate Functions
    
    func addToBasket(product: Product) {
        if UserDefaultsHelper.saveProductsToBasket(product: product).0 {
            SVProgressHUD.setMaximumDismissTimeInterval(0.5)
            SVProgressHUD.showSuccess(withStatus: "Added to basket")
        } else {
            SVProgressHUD.showError(withStatus: UserDefaultsHelper.saveProductsToBasket(product: product).1!)
        }
    }
    
    func addToFavorites(product: Product) {
        if UserDefaultsHelper.saveProductToWishList(product: product).0 {
//            SVProgressHUD.setMaximumDismissTimeInterval(1.5)
//            SVProgressHUD.showSuccess(withStatus: "Added to wishlist")
        } else {
            if !UserDefaultsHelper.removeProductFromWishList(product: product).0 {
                showAlert(title: "", message: UserDefaultsHelper.removeProductFromWishList(product: product).1!)
            }
        }
    }
}

extension ProductsViewController: UISearchBarDelegate {
    func filterContentForSearchText(searchText: String) {
        searchResults = self.values.filter({ (product) -> Bool in
            return product.title!.localizedStandardContains(searchText)
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            isSearching = true
            filterContentForSearchText(searchText: searchText)
            collectionView.reloadData()
        } else {
            isSearching = false
            collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.resignFirstResponder()
        searchBar.clear()
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = true
        view.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let count = searchBar.text?.count {
            if count == 0 {
                isSearching = false
                collectionView.reloadData()
            } else {
                isSearching = true
                collectionView.reloadData()
            }
        }
    }
    
}

extension UISearchBar {
    func clear() {
        self.text = nil
    }
}
