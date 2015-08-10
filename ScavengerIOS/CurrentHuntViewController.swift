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
            getLocationsForHunt(passedValue, completion: { (locations) -> () in
                if locations.count == 0 {
                    println("no locations were returned")
                    return
                }
                
                let lat = locations[0]["coordinate"]!.latitude
                let long = locations[0]["coordinate"]!.longitude
                let initialLocation = CLLocation(latitude: lat, longitude: long)
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
                self.huntMap.setRegion(coordinateRegion, animated: true)
                self.clueTextView.text = locations[0]["clue"] as! String
                
                
                
                
            })

//            let lat = passedValue["location"]!.latitude
//            let long = passedValue["location"]!.longitude
//            let initialLocation = CLLocation(latitude: lat, longitude: long)
//            println(passedValue["name"])
//            println(passedValue["clue"])
//            centerMapOnLocation(initialLocation)
//            clueTextView.text = passedValue["clue"] as! String

            
        }else {
            let initialLocation = CLLocation(latitude: 38.9047, longitude: -77.0164)
            centerMapOnLocation(initialLocation)
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
