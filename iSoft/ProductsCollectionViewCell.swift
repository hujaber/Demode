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

class ProductsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var delegate: ProductCellProtocol! = nil
    var cellProduct: Product?
    
    @IBOutlet weak var priceLabel: UILabel!
    public func fillCellWithProduct(product: Product) {
        cellProduct = product
        titleLabel.text = product.title
        priceLabel.text = product.salesPrice
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 0
        backgroundColor = UIColor.white
        if product.imageUrl != nil {
            let urlString = APIUrl.mainURL.appending(product.imageUrl!)
            let url = URL(string: urlString)!
            let resource = ImageResource.init(downloadURL: url)
            imageView.kf.setImage(with: resource, placeholder: nil, options: [], progressBlock: nil, completionHandler: { (image, error, cachetype, url) in
                
            })
        }

        titleLabel.sizeToFit()
        priceLabel.sizeToFit()
        
    }
    
    @IBAction func addToFavAction(_ sender: UIButton) {
        delegate.addToFavorites(product: self.cellProduct!)
    }
    
    @IBAction func addToBasketAction(_ sender: UIButton) {
        delegate.addToBasket(product: self.cellProduct!)
    }
    
    
    
    
}
