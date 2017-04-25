//
//  RegisterViewController.swift
//  iSoft
//
//  Created by Hussein Jaber on 18/4/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {

    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var fullNameTxtField: UITextField!
    
    @IBOutlet weak var passwordTxtField: UITextField!
    
    @IBOutlet weak var phoneNumberTxtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.myBlueColor()
        registerButton.layer.cornerRadius = 7
        setupTextFields()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupTextFields() {
        emailTxtField.textColor = UIColor.white
        fullNameTxtField.textColor = UIColor.white
        passwordTxtField.textColor = UIColor.white
        phoneNumberTxtField.textColor = UIColor.white
        
        emailTxtField.attributedPlaceholder = NSAttributedString.init(string: "Email Address", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        fullNameTxtField.attributedPlaceholder = NSAttributedString.init(string: "Full Name", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        passwordTxtField.attributedPlaceholder = NSAttributedString.init(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        phoneNumberTxtField.attributedPlaceholder = NSAttributedString.init(string: "Phone Number", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        fullNameTxtField.autocapitalizationType = .words
        emailTxtField.keyboardType = .emailAddress
        phoneNumberTxtField.keyboardType = .phonePad
        passwordTxtField.isSecureTextEntry = true
        
        fullNameTxtField.tintColor = UIColor.white
        emailTxtField.tintColor = UIColor.white
        passwordTxtField.tintColor = UIColor.white
        phoneNumberTxtField.tintColor = UIColor.white
        
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        if (((fullNameTxtField.text?.length) != nil) && ((emailTxtField.text?.length) != nil) && ((passwordTxtField.text?.length) != nil) && ((phoneNumberTxtField.text?.length) != nil)) {
            APIRequests.register(fullname: fullNameTxtField.text!, email: emailTxtField.text!, phoneNumber: phoneNumberTxtField.text!, password: passwordTxtField.text!, completion: { (success, error, errorMsg) in
                if (success) {
                    
                } else {
                    self.showAlert(title: "", message: errorMsg!)
                }
            })
        } else {
            showAlert(title: "Missing Fields", message: "Kindly fill all fields to register.")
        }
    }
    


}
