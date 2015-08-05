//
//  CurrentHuntViewController.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/3/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import UIKit
import MapKit
import Parse

class CurrentHuntViewController: UIViewController {
    @IBOutlet weak var huntMap: MKMapView!
    
    @IBOutlet weak var clueTextView: UITextView!
    
    var passedValue : PFObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
    }
    
    func setupMap() {
        // CHANGE THIS TO USE CORE LOCATION OF CURRENT LOCATION OF USER
        
        let regionRadius: CLLocationDistance = 1000
        
        func centerMapOnLocation(location : CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
            huntMap.setRegion(coordinateRegion, animated: true)
        }
        
        if let passedValue = passedValue {
            let lat = passedValue["location"]!.latitude
            let long = passedValue["location"]!.longitude
            let initialLocation = CLLocation(latitude: lat, longitude: long)
            println(passedValue["name"])
            println(passedValue["clue"])
            centerMapOnLocation(initialLocation)
            clueTextView.text = passedValue["clue"] as! String

            
        }else {
            let initialLocation = CLLocation(latitude: 38.9047, longitude: -77.0164)
            centerMapOnLocation(initialLocation)
        }
        
    }
}
