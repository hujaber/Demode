//
//  ShoppingBagViewController.swift
//  iSoft
//
//  Created by Hussein Jaber on 9/10/16.
//  Copyright © 2016 Hussein Jaber. All rights reserved.
//

import UIKit

class ShoppingBagViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shopping Bag"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func menuButtonPressed(_ sender: AnyObject) {
        openDrawer()
    }

}
