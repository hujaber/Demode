//
//  CodeController.swift
//  iSoft
//
//  Created by Hussein Jaber on 28/11/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit

class CodeController: BaseViewController {

    public var emailAddress: String?
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        submitBtn.layer.cornerRadius = 5
    }
    
    @IBAction func submitCodeAction(_ sender: UIButton) {
        if let code = codeTextField.text {
            if code == UserDefaultsHelper.getRandomGeneratedCode() {
                guard let email = emailAddress else { return }
                self.showLoader()
                APIRequests.verifyEmail(email: email, completion: { (success, error, message) in
                    self.hideLoader()
                    self.proceedToApp()
                })
            }
        } else {
            self.showAlert(title: "Wrong Code", message: "Please make sure you entered the code correctly")
        }
    }
    
    func proceedToApp() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBar: UITabBarController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CenterView") as! UITabBarController
        
        let loginScreen = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UINavigationController
        if (User.getCurrentUser() != nil) {
            appDelegate.window?.rootViewController = tabBar
        } else {
            appDelegate.window?.rootViewController = loginScreen
        }
    }
    


}
