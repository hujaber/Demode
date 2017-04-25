//
//  WishListViewController.swift
//  iSoft
//
//  Created by Hussein Jaber on 9/10/16.
//  Copyright © 2016 Hussein Jaber. All rights reserved.
//

import UIKit

class WishListViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Wishlist"
        // Do any additional setup after loading the view.
    }

    @IBAction func menuButtonPressed(_ sender: AnyObject) {
        openDrawer()
    }
}
