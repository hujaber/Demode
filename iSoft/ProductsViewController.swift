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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Pid= \(mainCatID!) and Lid= \(subCatID!)")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 0)
        layout.itemSize = CGSize(width: (screenWidth), height: (screenWidth/2))
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        collectionView!.backgroundColor = UIColor.white
        collectionView.bounces = true
        
        
        getProducts()
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
        return values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCell", for: indexPath) as! ProductsCollectionViewCell
        cell.delegate = self
        let product = self.values[indexPath.row]
        cell.fillCellWithProduct(product: product)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = values[indexPath.row]
        showLoader()
        APIRequests.getProductImages(withProductId: product.id!) { (success, error, images) in
            self.hideLoader()
            var myImages = [SKPhoto]()
            if (product.imageUrl != nil) {
                let photo = SKPhoto.photoWithImageURL(APIUrl.mainURL.appending(product.imageUrl!))
                photo.shouldCachePhotoURLImage = true
                if product.itemDescription != nil {
                    photo.caption = product.itemDescription!
                }

                myImages.append(photo)
            }

            for prodImage in images {
                if let imageURL = prodImage.imageUrl {
                    let photo = SKPhoto.photoWithImageURL(APIUrl.mainURL.appending(imageURL))
                    photo.shouldCachePhotoURLImage = true
                    if prodImage.imageDescription != nil {
                        photo.caption = prodImage.imageDescription
                    }

                    myImages.append(photo)
                }

            }
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
            SVProgressHUD.setMaximumDismissTimeInterval(1.5)
            SVProgressHUD.showSuccess(withStatus: "Added to basket")
        } else {
            SVProgressHUD.showError(withStatus: UserDefaultsHelper.saveProductsToBasket(product: product).1!)
        }
    }
    
    func addToFavorites(product: Product) {
        if UserDefaultsHelper.saveProductToWishList(product: product).0 {
            SVProgressHUD.setMaximumDismissTimeInterval(1.5)
            SVProgressHUD.showSuccess(withStatus: "Added to wishlist")
        } else {
            SVProgressHUD.showError(withStatus: UserDefaultsHelper.saveProductToWishList(product: product).1!)
        }
    }
}
