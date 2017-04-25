//
//  FirstViewController.swift
//  iSoft
//
//  Created by Hussein Jaber on 18/4/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit

class FirstViewController: BaseViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var passwordTxtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 7
        self.view.backgroundColor = UIColor.myBlueColor()
        let tapToDismiss = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapToDismiss)
        
        setupTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupTextFields() {
        passwordTxtField.isSecureTextEntry = true
        passwordTxtField.borderStyle = .none
        emailTxtField.borderStyle = .none
        emailTxtField.tintColor = UIColor.white
        passwordTxtField.tintColor = UIColor.white
        passwordTxtField.textColor = UIColor.white
        emailTxtField.textColor = UIColor.white
        
        emailTxtField.keyboardType = .emailAddress
        
        emailTxtField.attributedPlaceholder = NSAttributedString.init(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.white])
        passwordTxtField.attributedPlaceholder = NSAttributedString.init(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
    }
    
    func dismissKeyboard() -> Void {
        view.endEditing(true)
    }

    //MARK: - IBActions
    @IBAction func loginAction(_ sender: UIButton) {
        passwordTxtField.resignFirstResponder()
        let email = emailTxtField.text
        let password = passwordTxtField.text
        showWhiteLoader()
        APIRequests.login(with: email!, password: password!) { (success, error, errorMessage, user) in
            self.hideLoader()
            if (!success) {
                self.showAlert(title: "", message: errorMessage!)
            } else {
                self.getAppDelegate().window?.rootViewController = self.getAppDelegate().drawerController
            }
            
        }
    }
}