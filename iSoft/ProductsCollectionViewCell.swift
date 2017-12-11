//
//  ProductsCollectionViewCell.swift
//  iSoft
//
//  Created by Hussein Jaber on 8/1/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit
import Kingfisher

protocol ProductCellProtocol {
    func addToBasket(product: Product)
    func addToFavorites(product: Product)
}

extension String {
     func addDollarSign() -> String {
        return "$" + self
    }
}

class ProductsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var delegate: ProductCellProtocol! = nil
    var cellProduct: Product?
    
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    public func fillCellWithProduct(product: Product) {
        cellProduct = product
        titleLabel.text = product.title
        priceLabel.text = product.salesPrice!.addDollarSign()
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 0
        backgroundColor = UIColor.white
        imageView.contentMode = .scaleAspectFill
        
        if let thumbImgURL = product.thumbImageURL {
            let urlString = APIUrl.mainURL.appending(thumbImgURL)
            let url = URL(string: urlString)!
            let resource = ImageResource.init(downloadURL: url)
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: resource, placeholder: nil, options: [], progressBlock: nil, completionHandler: { (image, error, cachetype, url) in
                
            })
        }
        favButton.setImage(#imageLiteral(resourceName: "favBorder"), for: .normal)
        if let savedFavs = UserDefaultsHelper.getWishlistProducts() {
            for favProd in savedFavs {
                if product.id! == favProd.id! {
                    favButton.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
                }
            }
        }
        
        titleLabel.sizeToFit()
        priceLabel.sizeToFit()
        
    }
    
    @IBAction func addToFavAction(_ sender: UIButton) {
        if favButton.image(for: .normal) == #imageLiteral(resourceName: "fav") {
            favButton.setImage(#imageLiteral(resourceName: "favBorder"), for: .normal)
        } else {
            favButton.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
        }
        
        delegate.addToFavorites(product: self.cellProduct!)
    }
    
    @IBAction func addToBasketAction(_ sender: UIButton) {
        delegate.addToBasket(product: self.cellProduct!)
    }
    
    
    
    
}
