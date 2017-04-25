//
//  AboutViewController.swift
//  iSoft
//
//  Created by Hussein Jaber on 9/10/16.
//  Copyright © 2016 Hussein Jaber. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About Us"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonPressed(_ sender: AnyObject) {
        openDrawer()
    }
}
