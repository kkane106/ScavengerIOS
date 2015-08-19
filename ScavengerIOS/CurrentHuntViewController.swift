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
    
    var locationCounter = 0
    var skipCounter = 0
    
    var completedHunt : PFObject?
    var passedLocations : [PFObject]?
    let locationManager = CLLocationManager()
    var objective : CLLocation?
    
    let π = M_PI

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        findUser()
        setupMap(locationCounter)
    }

    func toRadians(degrees: Double) -> Double {
        let radians = ( degrees * π) / 180
        return radians
    }

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
    
    @IBAction func doCheckLocation(sender: UIBarButtonItem) {
        checkLocation()
    }
    
    func findUser() {
        var userLocation = locationManager.location
        if let userLocation = userLocation {
            println(userLocation)
        }
        let coordinate = userLocation.coordinate
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)
        huntMap.setRegion(region, animated: true)
    }
    
    func checkLocation() {
        var userLocation = huntMap.userLocation.location?.coordinate
        println("User Location: \(userLocation!)")
        zoomToCurrentUserLocationInMap(huntMap)
        let currentLat = userLocation!.latitude
        let currentLong = userLocation!.longitude
        if let objective = objective {
            
            let distance = haversineFormula(currentLat, lat2: objective.coordinate.latitude, lon1: currentLong, lon2: objective.coordinate.longitude)
            println(distance)
            
            if distance < 3000 {
                

                if locationCounter >= (passedLocations!.count - 1) {
                    
                    checkCompletion()
                    
                } else {
                    var alert = UIAlertView()
                    alert.title = "You're there"
                    alert.addButtonWithTitle("Cool!")
                    alert.show()
                    println(locationCounter)
                    
                    ++self.locationCounter
                    setupMap(self.locationCounter)
                    return
                }
                
            }
        }

    }
    
    func checkCompletion() {
        if let passedLocations = passedLocations {
            updateCompletedHunt({ (result) -> () in
                self.completedHunt = result
                println("func checkCompletion finished updating CompletedHunt")
                var alert = UIAlertView()
                alert.title = "YOU DID IT!!!!!"
                alert.addButtonWithTitle("Show me my time!")
                alert.show()
                self.performSegueWithIdentifier("showScoresSegue", sender: nil)
            })
           
            
        } else {
            println("func checkCompletion error")
        }
    }
    
    func updateCompletedHunt(completion : (result : PFObject) -> ()) {
        var query = PFQuery(className: "completedHunts")
        query.orderByDescending("createdAt")
        query.getFirstObjectInBackgroundWithBlock { (response : AnyObject?, error : NSError?) -> Void in
            if error != nil {
                println(error)
            } else {
                if let response = response {
                    println("This is the response from updateCompletedHunt: \n \(response)")
                    var game = response as! PFObject
                    var time = Time()
                    game["endTime"] = time.now()
                    if let startTime: AnyObject = game["startTime"] {
                        let start = String(stringInterpolationSegment: startTime)
                        println("This should be startTime: \(start)")
                        if let endTime: AnyObject = game["endTime"] {
                            let end = String(stringInterpolationSegment: endTime)
                            println("This should be endTime: \(end)")
                            var totalTime = ElapsedTime(startTime: start, endTime: end )
                            println("This should be totalTime: \(totalTime)")
                            game["completeLocations"] = (self.passedLocations!.count - self.skipCounter)
                            game["totalTime"] = totalTime.convertStringsToSeconds()
                            game["complete"] = self.didTheySkip()
                            game.saveInBackgroundWithBlock { (success, error: NSError?) -> Void in
                                if error != nil {
                                    println(error)
                                } else {
                                    println("success")
                                    completion(result: game)
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        
    }
    
    func didTheySkip() -> Bool {
        if skipCounter > 0 {
            return false
        }
       return true
    }
    
    func zoomToCurrentUserLocationInMap(mapView: MKMapView) {
        if let coordinate = mapView.userLocation.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func setupMap(counter : Int) {
        if let passedLocations = passedLocations {
            didReceiveLocations(passedLocations, completion: { (locations) -> () in
                if locations.count == 0 {
                    println("no locations were returned")
                    return
                }
                
                let lat = locations[counter]["coordinate"]!.latitude
                let long = locations[counter]["coordinate"]!.longitude
                let initialLocation = CLLocation(latitude: lat, longitude: long)
                self.clueTextView.text = locations[counter]["clue"] as! String
                
                self.objective = initialLocation

            })
        } else {
            println("not centered on first location")
        }
    }
    
    func didReceiveLocations(passedLocations : [PFObject], completion : (locations : [PFObject]) -> ()) {
        let receivedLocations = passedLocations
        completion(locations: receivedLocations)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showScoresSegue") {
            var destinationVC = segue.destinationViewController as! ScoresViewController
            if let completedHunt = completedHunt {
                destinationVC.completedHunt = completedHunt
            }
        }

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
