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
import Darwin // Math
import Foundation

class CurrentHuntViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var huntMap: MKMapView!
    
    @IBOutlet weak var clueTextView: UITextView!
    
    var passedValue : PFObject?
    let locationManager = CLLocationManager()
    var objective : CLLocation?
    
    let π = M_PI

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        setupMap()
    }
    // Make this a struct
    func toRadians(degrees: Double) -> Double {
        let radians = ( degrees * π) / 180
        return radians
    }
    // Make this a struct
    func haversineFormula(lat1: Double, lat2: Double, lon1: Double, lon2: Double) -> Double  {
        let R = 6371000.0 // Meters
        let lat1R = toRadians(lat1)
        let lat2R = toRadians(lat2)
        let latDiff = toRadians(lat2 - lat1)
        let lonDiff = toRadians(lon2 - lon1)
        
        var a = sin(latDiff/2) * sin(latDiff/2) + cos(lat1R) * cos(lat2R) * sin(lonDiff/2) * sin(lonDiff/2)
        var c = 2 * atan2(sqrt(a), sqrt(1-a))
        var d = R * c
        
        return d // In Meters
    }
    
    @IBAction func doFindMe(sender: UIBarButtonItem) {
        var userLocation = huntMap.userLocation.location?.coordinate
        println("User Location: \(userLocation)")
        zoomToCurrentUserLocationInMap(huntMap)
        let currentLat = userLocation!.latitude
        let currentLong = userLocation!.longitude
        if let objective = objective {
            
            let distance = haversineFormula(currentLat, lat2: objective.coordinate.latitude, lon1: currentLong, lon2: objective.coordinate.longitude)
            println(distance)
            
            if distance < 30 {

                var alert = UIAlertView()
                alert.title = "You're there"
                alert.addButtonWithTitle("Cool!")
                alert.show()
                return
            
            }
        }
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
        
        if let passedValue = passedValue {
            getLocationsForHunt(passedValue, completion: { (locations) -> () in
                if locations.count == 0 {
                    println("no locations were returned")
                    return
                }
                
                let lat = locations[0]["coordinate"]!.latitude
                let long = locations[0]["coordinate"]!.longitude
                let initialLocation = CLLocation(latitude: lat, longitude: long)
//                let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, regionRadius, regionRadius)
//                self.huntMap.setRegion(coordinateRegion, animated: true)
                self.clueTextView.text = locations[0]["clue"] as! String
                
                self.objective = initialLocation
                
                

            })

        }else {
            println("not centered on first location")
        }
        
    }
    
    func getLocationsForHunt(hunt : PFObject, completion: (locations : [PFObject]) -> ()) {
        let query = PFQuery(className: "Location")
        query.whereKey("ScavengerHuntId", equalTo: hunt)
        query.findObjectsInBackgroundWithBlock({
            (results, error : NSError?) -> Void in
            if error != nil {
                if let error = error {
                    println("error")
                }
            }
            println(results)
            if let results = results {
                completion(locations: results as! [PFObject])
            }
        })
        
    }
}

//        getSavedData { (data) -> () in
//            println("Here is data: \(data)")
//        }


//}

//    func getSavedData(completion: (data: PFObject) -> ()) {
//        let query = PFQuery(className: "ScavengerHunt")
//        let results = query.getFirstObject()
//        if let results = results {
//            completion(data: results)
//        }
//    }
