//
//  FindStoreViewController.swift
//  iSoft
//
//  Created by Hussein Jaber on 9/10/16.
//  Copyright © 2016 Hussein Jaber. All rights reserved.
//

import UIKit
import GoogleMaps

class FindStoreViewController: BaseViewController {
    var mapView: GMSMapView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Find a Store"
        mapView = view as? GMSMapView
        //33.843556, 35.497529
        let location = CLLocationCoordinate2D(latitude: 33.843556, longitude: 35.497529)
        let marker = GMSMarker(position: location)
        marker.snippet = "Assaha Hotel"
        marker.map = mapView
        mapView?.camera = GMSCameraPosition(target: location, zoom: 12.0, bearing: 0, viewingAngle: 0)
    }
    
    @IBAction func menuButtonPressed(_ sender: AnyObject) {
        openDrawer()
    }
    

}
