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
        
        emailTxtField.attributedPlaceholder = NSAttributedString.init(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        fullNameTxtField.attributedPlaceholder = NSAttributedString.init(string: "Full Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        passwordTxtField.attributedPlaceholder = NSAttributedString.init(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        phoneNumberTxtField.attributedPlaceholder = NSAttributedString.init(string: "Phone Number", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        fullNameTxtField.autocapitalizationType = .words
        emailTxtField.keyboardType = .emailAddress
        phoneNumberTxtField.keyboardType = .phonePad
        passwordTxtField.isSecureTextEntry = true
        
        fullNameTxtField.tintColor = UIColor.white
        emailTxtField.tintColor = UIColor.white
        passwordTxtField.tintColor = UIColor.white
        phoneNumberTxtField.tintColor = UIColor.white
        let label = UILabel(frame: CGRect.init(0, 0, 50, phoneNumberTxtField.frame.height))
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .white
        label.text = "+961"
        label.translatesAutoresizingMaskIntoConstraints = true
        phoneNumberTxtField.leftView = label
        phoneNumberTxtField.leftViewMode = .always
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CodeController {
            vc.emailAddress = emailTxtField.text
        }
     }
    
    @IBAction func registerAction(_ sender: UIButton) {
        if (((fullNameTxtField.text?.length) != nil) && ((emailTxtField.text?.length) != nil) && ((passwordTxtField.text?.length) != nil) && ((phoneNumberTxtField.text?.length) != nil)) {
            
            let randomNumber = generateRandomNumber()
            UserDefaultsHelper.saveRandomGeneratedCode(string: randomNumber)
            self.showLoader()
            APIRequests.register(fullname: fullNameTxtField.text!, email: emailTxtField.text!, phoneNumber: "961" + phoneNumberTxtField.text!, password: passwordTxtField.text!, randomCode: randomNumber, completion: { (success, error, errorMsg) in
                self.hideLoader()
                if (success) {
                    self.performSegue(withIdentifier: "segueToCodeController", sender: self)
                } else {
                    if let errorMessage = errorMsg {
                        self.showAlert(title: "", message: errorMessage)
                    } else {
                        self.showAlert(title: "", message: "Something went wrong.")
                    }
                }
            })
        } else {
            showAlert(title: "Missing Fields", message: "Kindly fill all fields to register.")
        }
    }
    
    func generateRandomNumber() -> String {
        let digits = 0...9
        
        // Shuffle them
        let shuffledDigits = digits.shuffled()
        
        // Take the number of digits you would like
        let fourDigits = shuffledDigits.prefix(4)
        
        // Add them up with place values
        let value = fourDigits.reduce(0) {
            $0*10 + $1
        }
        
        return value.toString()
    }
}

extension Int {
    func toString() -> String {
        return "\(self)"
    }
}

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            self.swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}


