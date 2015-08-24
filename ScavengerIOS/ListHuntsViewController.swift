//
//  ListHuntsViewController.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/3/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse
import Darwin // Math
import Foundation

class ListHuntsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    @IBOutlet weak var scavengerHuntsTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    var currentGeoPoint : PFGeoPoint?

    let locManager = CLLocationManager()
    let cellID = "ScavengerHuntCell"
    var scavengerHuntToPass : PFObject?
    var searchDistance : Float = 10.0
    
    let π = M_PI
    
    var scavengerHunts = [PFObject]()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.currentUser() == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewControllerWithIdentifier("loginVC") as! LoginViewController
            self.presentViewController(loginVC, animated: true, completion: nil)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateScavengerHunts(searchDistance, completion: { (response) -> () in
            self.scavengerHunts = response
            self.scavengerHuntsTableView.reloadData()
            
        })
        if (CLLocationManager.locationServicesEnabled())
        {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.requestAlwaysAuthorization()
            locManager.startUpdatingLocation()
            
        }
        

        
        
        scavengerHuntsTableView.delegate = self
        scavengerHuntsTableView.dataSource = self
    }
    
    @IBAction func doSignOut(sender: UIBarButtonItem) {
        PFUser.logOut()
        println("current user: \(PFUser.currentUser())")
        presentLoginVC()
        
    }
    @IBAction func doSearchWithDistance(sender: UIButton) {
        if self.searchTextField.text != "" {
            println(self.searchDistance)
            let userSearch : NSString = self.searchTextField.text as! NSString
            self.searchDistance = userSearch.floatValue
            println(self.searchDistance)
            updateScavengerHunts(self.searchDistance, completion: { (response) -> () in
                self.scavengerHunts = response
                self.scavengerHuntsTableView.reloadData()
                
            })
        }
    }
    
    func presentLoginVC() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("loginVC") as! LoginViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
//    func updateScavengerHunts(sender: UIRefreshControl) {
//        var query = PFQuery(className: "ScavengerHunt")
//        query.orderByDescending("updatedAt")
//        query.findObjectsInBackgroundWithBlock {
//            (response, error) -> Void in
//            if error != nil {
//                println("didn't work")
//                return
//            }
//            
//            if let response = response {
//                self.scavengerHunts = response as! [PFObject]
//                println("RESPONSE AS LIST OF SCAVENGER HUNTS: \(response)")
//            }
//            sender.endRefreshing()
//            self.scavengerHuntsTableView.reloadData()
//        }
//    }
    
    // Haversine Formula for calculating proximity for display
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
    // end haversine
    
    
    func updateScavengerHunts(radius : Float, completion : (response : [PFObject]) -> ()) {
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint : PFGeoPoint?, error: NSError?) -> Void in
            if error != nil {
                println("no location found")
            } else {
                if let geoPoint = geoPoint {
                    self.currentGeoPoint = geoPoint
                    let userGeoPoint = geoPoint
                    var query = PFQuery(className: "ScavengerHunt")
                    query.whereKey("startingPoint", nearGeoPoint: userGeoPoint, withinMiles: 10.0)
                    query.limit = 20
                    let placesObjects = query.findObjectsInBackgroundWithBlock({ (response, error) -> Void in
                        if error != nil {
                            println("no location objects returned")
                        } else {
                            if let response = response {
                                completion(response: response as! [PFObject])

                            }
                            
                        }
                    })
                }
            }
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as! ScavengerHuntTableViewCell
        let currentHunt = scavengerHunts[indexPath.row]
        cell.scavengerHuntName?.text = currentHunt["name"] as! String
        if let currentGeoPoint = currentGeoPoint {
            if let startPoint = currentHunt["startingPoint"] as? PFGeoPoint {
                println("START POINT! : \(startPoint)")
                println("CURRENT GEOPOINT : \(currentGeoPoint)")
                let proximity = haversineFormula(
                    currentGeoPoint.latitude,
                    lat2: startPoint.latitude,
                    lon1: currentGeoPoint.longitude,
                    lon2: startPoint.longitude
                )
                let proximityInMiles = Double(round(10 * (proximity * 0.000621371))/10)
                println("PROXIMITY : \(proximity) meters")
                println("PROXIMITY : \(proximityInMiles) miles")
                cell.scavengerHuntProximity?.text = String(stringInterpolationSegment: proximityInMiles) + " miles"
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scavengerHunts.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow()
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
        
        if let indexPath = indexPath {
            scavengerHuntToPass = scavengerHunts[indexPath.row]
        }
        performSegueWithIdentifier("showHuntDescription", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showHuntDescription") {
            var destinationVC = segue.destinationViewController as! HuntDescriptionViewController
            if let scavengerHuntToPass = scavengerHuntToPass {
                destinationVC.receivedScavengerHunt = scavengerHuntToPass
                
            }
        }
        
        if (segue.identifier == "logoutSegueView") {
            var destinationVC = segue.destinationViewController as! LoginViewController
        }

    }
    
}
