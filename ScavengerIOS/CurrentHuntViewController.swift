//
//  CurrentHuntViewController.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/3/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import UIKit
import MapKit

class CurrentHuntViewController: UIViewController {
    @IBOutlet weak var huntMap: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
    }
    
    func setupMap() {
        // CHANGE THIS TO USE CORE LOCATION OF CURRENT LOCATION OF USER
        let initialLocation = CLLocation(latitude: 38.9047, longitude: -77.0164)
        
        let regionRadius: CLLocationDistance = 1000
        
        func centerMapOnLocation(location : CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
            huntMap.setRegion(coordinateRegion, animated: true)
        }
        
        centerMapOnLocation(initialLocation)
        
    }
}
