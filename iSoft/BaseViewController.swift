//
//  BaseViewController.swift
//  iSoft
//
//  Created by Hussein Jaber on 9/10/16.
//  Copyright © 2016 Hussein Jaber. All rights reserved.
//

import UIKit
import DrawerController
import SVProgressHUD
import SCLAlertView


class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getDrawerFromAppDelegate() -> DrawerController {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let drawer = appDelegate.drawerController
        return drawer!
    }
    
    public func openDrawer() {
        let drawer = getDrawerFromAppDelegate()
        drawer.toggleLeftDrawerSide(animated: true, completion: nil)
    }
    
    public func showLoader() {
        SVProgressHUD.setBackgroundColor(UIColor.myBlueColor())
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setDefaultMaskType(.gradient)
        
        SVProgressHUD.show(withStatus: "Loading...")
    }
    
    public func showWhiteLoader() {
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.myBlueColor())
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.show(withStatus: "Loading...")
    }
    
    public func hideLoader() {
        SVProgressHUD.dismiss()
    }
    
    public func showAlert(title: String, message: String) {
        SCLAlertView().showTitle(
            title,
            subTitle: message,
            duration: 0.0,
            completeText: "Okay",
            style: .warning,
            colorStyle: 0x18425F,
            colorTextButton: 0xFFFFFF
            
        )
    }
    
    public func getAppDelegate() -> AppDelegate {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        return appdelegate
    }
    
    public func addBottomBorder(textField: UITextField) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }


}
