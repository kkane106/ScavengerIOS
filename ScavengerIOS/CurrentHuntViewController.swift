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
import CoreLocation

class CurrentHuntViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var huntMap: MKMapView!
    
    @IBOutlet weak var clueTextView: UITextView!
    
    var passedValue : PFObject?
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        
        setupMap()
    }
    
    @IBAction func doFindMe(sender: UIBarButtonItem) {
        println("THIS: \(huntMap.userLocation.location?.coordinate)")
        zoomToCurrentUserLocationInMap(huntMap)
    }
    
    func zoomToCurrentUserLocationInMap(mapView: MKMapView) {
        if let coordinate = mapView.userLocation.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 5000, 5000)
            mapView.setRegion(region, animated: true)
        }
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
