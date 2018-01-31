//
//  PrepareForCheckoutViewController.swift
//  iSoft
//
//  Created by Hussein Jaber on 23/7/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit

class PrepareForCheckoutViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    let cellId = "PQLCell"
    let prodCell = "prodCell"
    var tableValues = Array<Product>()
    
    //MARK: - UITextFields
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tableVals = UserDefaultsHelper.getBasketProducts() {
            tableValues = tableVals
        }
        setupTableView()


    }

    @IBAction func continueAction(_ sender: UIButton) {
        if tableValues.count > 0 {
            performSegue(withIdentifier: "segueToAddress", sender: self)
        } else {
            self.showAlert(title: "", message: "Please add products to the basket before proceeding")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddressController {
            vc.products = tableValues
        }
    }
    
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableValues.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: prodCell) as! ProdCell
            let product = tableValues[indexPath.row - 1]
            cell.setCellWithProduct(product: product)
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let customView = UIView.init(frame: CGRect.init(0, 0, tableView.frame.width, 30))
        customView.backgroundColor = UIColor.black
        let label = UILabel.init(frame: CGRect(0, 0, view.frame.width, 30))
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        var totalPrice: Float = 0
        for product in tableValues {
            if let price = product.salesPrice {
                let floatPrice = Float(price)
                if let final = floatPrice {
                    totalPrice = totalPrice + (final * product.quantity!.toFloat())
                }
            }
        }
        let price = "\(totalPrice)".addDollarSign()
        label.text = "Total:\t\t\t" + price
        customView.addSubview(label)
        
        return customView
    }
    

}

extension String {
    func toFloat() -> Float {
        return Float(self)!
    }
}


class ProdCell: UITableViewCell {
    
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    func setCellWithProduct(product: Product) {
        productNameLabel.text = product.title!
        productQuantityLabel.text = product.quantity!
        let quantity = Int(product.quantity!)
        let price = Int(product.salesPrice!)
        let totalPrice = quantity! * price!
        productPriceLabel.text = "\(totalPrice)".addDollarSign()
    }
    
}
