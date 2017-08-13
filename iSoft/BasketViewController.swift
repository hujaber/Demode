//
//  BasketViewController.swift
//  iSoft
//
//  Created by Hussein Jaber on 2/2/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit
import Kingfisher
import Spring

class BasketViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var orderNowButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //Alert View
    @IBOutlet var alertView: SpringView!
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var alertPriceLabel: UILabel!
    @IBOutlet weak var alertMinusButton: UIButton!
    @IBOutlet weak var alertPlusButton: UIButton!
    @IBOutlet weak var alertQuantityTextField: UITextField!
    @IBOutlet weak var alertCancelButton: UIButton!
    var alertProduct: Product?
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    
    var tableValues: Array<Product>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        prepareButton()
    }
    
    func setupTableView() {
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = UIView.init()
        tableValues = UserDefaultsHelper.getBasketProducts()
        self.tableView.reloadData()
    }
    
    func refreshTableView() {
        tableValues = UserDefaultsHelper.getBasketProducts()
        tableView.reloadData()
    }
    
    func prepareButton() {
        orderNowButton.setTitle("Order Now", for: .normal)
        orderNowButton.setTitleColor(UIColor.white, for: .normal)
        orderNowButton.backgroundColor = UIColor.myBlueColor()
        orderNowButton.layer.cornerRadius = 7
    }
    
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard tableValues?.count != nil else {
            return 0
        }
        return (tableValues!.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketCell") as! BasketCell
        cell.setCellWithBasketItem(product: (tableValues?[indexPath.section])!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showAlertViewWithProduct(product: tableValues?[indexPath.section])
    }
    
    
    @IBAction func toCheckoutAction(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToOrder", sender: self)
    }
    

    func showAlertViewWithProduct(product: Product?) {
        tableView.isUserInteractionEnabled = false
        addBlurToView(enable: true)
        setupAlertView(product: product!)
        alertView.animation = "slideDown"
        alertView.curve = "easeIn"
        alertView.duration = 0.5
        alertView.force = 1.5
        alertView.delay = 0.1
        alertView.animateFrom = true
        alertView.x = 0
        alertView.y = 0
        self.view.addSubview(self.alertView)
        alertView.animate()
    }
    
    func dismissAlert() {
        
        UIView.animate(withDuration: 1.0, delay: 0.1, usingSpringWithDamping: 10, initialSpringVelocity: 12, options: .beginFromCurrentState, animations: {
            self.alertView.animation = "fall"
            self.alertView.curve = "easeIn"
            self.alertView.animate()
        }) { (ended) in
            self.alertView.removeFromSuperview()
            self.addBlurToView(enable: false)
        }
       // alertView.removeFromSuperview()

        
    }
    
    func setupAlertView(product: Product) {
        alertView.center = (navigationController?.view.center)!
        alertView.layer.cornerRadius = 7
        alertView.layer.borderColor = UIColor.black.cgColor
        alertView.layer.borderWidth = 0.5
        alertTitleLabel.text = product.title
        alertPriceLabel.text = product.oldPrice
        alertQuantityTextField.text = product.quantity!
        alertProduct = product
        if let prodURL = product.imageUrl {
            let url = URL(string: APIUrl.mainURL + prodURL)
            let resource = ImageResource.init(downloadURL: url!)
            alertImageView.kf.indicatorType = .activity
            alertImageView.kf.setImage(with: resource, placeholder: nil, options: nil, progressBlock: nil) { (image, error, cacheType, url) in
                
            }
        }

    }
    
    func addBlurToView(enable: Bool) {
        if enable {

            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 2, initialSpringVelocity: 1, options: .curveEaseIn, animations: { 
                self.view.addSubview(self.blurEffectView)
            }, completion: { (completed) in
                
            })
        } else {
            blurEffectView.removeFromSuperview()
        }
        
    }
    
    @IBAction func alertCancelAction(_ sender: UIButton) {
        //alertView.removeFromSuperview()
        dismissAlert()
        tableView.isUserInteractionEnabled = true
        //addBlurToView(enable: false)
    }
    
    @IBAction func confirmAction(_ sender: UIButton) {
        let quantity = alertQuantityTextField.text
        UserDefaultsHelper.updateProductInBasket(product: alertProduct!, quantity: quantity!)
        refreshTableView()
        alertView.removeFromSuperview()
        tableView.isUserInteractionEnabled = true
        addBlurToView(enable: false)
    }
    
    @IBAction func alertPlusAction(_ sender: UIButton) {
        var quantity = Int(alertQuantityTextField.text!)
        quantity! = quantity! + 1
        alertQuantityTextField.text = "\(quantity!)"

    }
    
    @IBAction func alertMinusAction(_ sender: UIButton) {
        var quantity = Int(alertQuantityTextField.text!)
        if quantity! > 1 {
            quantity = quantity! - 1
        }
        alertQuantityTextField.text = "\(quantity!)"
    }
    


    
}

class BasketCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    func setCellWithBasketItem(product: Product) {
        productTitle.text = product.title
        quantityLabel.text = product.quantity!
        itemPriceLabel.text = product.oldPrice
        totalPriceLabel.text = "0000"
        if let prodURL = product.imageUrl {
            let url = URL(string: APIUrl.mainURL + prodURL)
            let resource = ImageResource.init(downloadURL: url!)
            productImageView.kf.indicatorType = .activity
            productImageView.kf.setImage(with: resource, placeholder: nil, options: [], progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                
            })
        }

    }
}












