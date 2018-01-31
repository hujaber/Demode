//
//  AddressController.swift
//  iSoft
//
//  Created by Hussein Jaber on 4/12/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit

class AddressController: BaseViewController {

    //MARK: -UITextFields
    var products: [Product]?
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var buildingTxtField: UITextField!
    @IBOutlet weak var additionalInfoTxtField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    var params = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.layer.cornerRadius = 5
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTextFields()
    }
    
    func setupTextFields() {
        let font = UIFont.boldSystemFont(ofSize: 17)
        firstNameTxtField.addBottomBorder()
        firstNameTxtField.placeholder = "First Name"
        firstNameTxtField.font = font
        firstNameTxtField.autocapitalizationType = .words
        
        lastNameTxtField.addBottomBorder()
        lastNameTxtField.placeholder = "Last Name"
        lastNameTxtField.font = font
        lastNameTxtField.autocapitalizationType = .words
        
        addressTextField.addBottomBorder()
        addressTextField.placeholder = "Address"
        addressTextField.font = font
        additionalInfoTxtField.autocapitalizationType = .words
        
        countryTextField.addBottomBorder()
        countryTextField.placeholder = "Country"
        countryTextField.font = font
        countryTextField.autocapitalizationType = .words
        
        cityTextField.addBottomBorder()
        cityTextField.placeholder = "City"
        cityTextField.font = font
        cityTextField.autocapitalizationType = .words
        
        streetTextField.addBottomBorder()
        streetTextField.placeholder = "Street"
        streetTextField.font = font
        streetTextField.autocapitalizationType = .words
        
        buildingTxtField.addBottomBorder()
        buildingTxtField.placeholder = "Building"
        buildingTxtField.font = font
        buildingTxtField.autocapitalizationType = .words
        
        additionalInfoTxtField.addBottomBorder()
        additionalInfoTxtField.placeholder = "Additional Info"
        additionalInfoTxtField.font = font
        additionalInfoTxtField.autocapitalizationType = .sentences
    }

    @IBAction func submitAction(_ sender: UIButton) {
        // fetch all data from list
        if !userDidFillAllDataAndPrepareParams() {
            self.showAlert(title: "", message: "Kindly fill all required fields.")
        }
    }
    
    @discardableResult
    func userDidFillAllDataAndPrepareParams() -> Bool {
        
        guard let address = addressTextField.text else {
            self.showAlert(title: "", message: ErrorStrings.address.rawValue)
            return false
        }
        
        guard let country = countryTextField.text else {
            self.showAlert(title: "", message: ErrorStrings.country.rawValue)
            return false
        }
        
        guard let city = cityTextField.text else {
            self.showAlert(title: "", message: ErrorStrings.city.rawValue)
            return false
            
        }
        
        guard let street = streetTextField.text else {
            self.showAlert(title: "", message: ErrorStrings.street.rawValue)
            return false
        }
        
        guard let building = buildingTxtField.text else {
            self.showAlert(title: "", message: ErrorStrings.building.rawValue)
            return false
        }
        guard let email = User.getCurrentUser()?.email else {
            return false
        }
        guard let phone = User.getCurrentUser()?.phone else {
            return false
        }
        params["email"] = email
        params["phone_num_1"] = phone
        params["address_name"] = address
        params["street_name_num"] = street
        params["building_name_num"] = building
        params["currency"] = "$"
        params["sum"] = 3000
        params["City"] = city
        params["Country"] = country
        if let additionalInfo = additionalInfoTxtField.text {
           params["extradata"] = additionalInfo
        } else {
            params["extradata"] = ""
        }
        params["floor"] = ""
        params["phone_num_2"] = ""
        params["area"] = ""
        params["block"] = ""
        params["apartment"] = ""
        params["Latitude"] = 0
        params["Longtitude"] = 0
        params["Elevation"] = 0
        /**/

        addOrderRequest(params: params)
        return true
    }
    // $order_id,".$row['product_id'].",".$row['sales_price'].",".$row['Quantity'].
    func addOrderRequest(params: [String : Any]) {
        self.showLoader()
        APIRequests.addOrder(params: params) { (success, error, orderId) in
            self.hideLoader()
            if success {
                if let orderId = orderId {
                    var orderArray = [[String : Any]]()
                    for product in self.products! {
                        var orderDictionary = [String : Any]()
                        orderDictionary["order_id"] = orderId.toInt()
                        orderDictionary["product_id"] = product.id!.toInt()
                        orderDictionary["sales_price"] = product.oldPrice!.toDouble()
                        orderDictionary["Quantity"] = product.quantity!.toInt()
                        orderArray.append(orderDictionary)
                    }
                    if orderArray.count > 0 {
                        APIRequests.uploadItems(orderId: orderId, orderArray: orderArray, completion: { (success, error, errorString) in
                            if success {
                                self.showAlert(title: "Order Complete", message: "")
                                UserDefaultsHelper.deleteBasket()
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        })
                    }
                }
            } else {
                self.showAlert(title: "", message: "Something went wrong")
            }
        }
    }
}

extension String {
    func toInt() -> Int {
        return Int(self)!
    }
    
    func toDouble() -> Double {
        return Double(self)!
    }
}



fileprivate enum ErrorStrings: String {
    case firstName = "Kindly enter your first name"
    case lastName = "Kindly enter your last name"
    case address = "Kindly enter your address"
    case country = "Kindly enter your country"
    case city = "Kindly enter your city"
    case street = "Kindly enter your street"
    case building = "Kindly enter your building number or name"
}
