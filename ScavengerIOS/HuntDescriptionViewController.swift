//
//  HuntDescriptionViewController.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/18/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation

class HuntDescriptionViewController: UIViewController {

    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scavengerHuntNameLabel: UILabel!
    @IBOutlet weak var numberOfLocationsLabel: UILabel!

    var receivedScavengerHunt : PFObject?
    var locationsForHunt : [PFObject]?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        setupDescription()
    }
    
    override func viewDidLoad() {
        
    super.viewDidLoad()


    }
    
    func setupDescription() {
        if let receivedScavengerHunt = receivedScavengerHunt {
            getDetailsForHunt(receivedScavengerHunt, completion: { (description, name, locations) -> () in
                self.descriptionLabel.text = description
                self.scavengerHuntNameLabel.text = name
                self.numberOfLocationsLabel.text = String(locations.count)
                self.locationsForHunt = locations
                
            })
        }
    }
    @IBAction func beginScavengerHunt(sender: UIButton) {
        var time = Time()
        var newGame = PFObject(className: "completedHunts")
        newGame["startTime"] = time.now()
        newGame["PlayerId"] = PFUser.currentUser()
        newGame["ScavengerHuntId"] = receivedScavengerHunt!
        newGame["totalLocations"] = locationsForHunt!.count
        newGame.saveInBackgroundWithBlock { (success, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else {
                println("success")
            }
        }
        
        performSegueWithIdentifier("showCurrentHunt", sender: self)
    }
    
    func getDetailsForHunt(hunt : PFObject, completion: (description : String, name : String, locations : [PFObject]) -> ()) {
        let passedDescription = hunt["description"] as! String
        let passedName = hunt["name"] as! String
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
                completion(description: passedDescription, name: passedName, locations : results as! [PFObject])
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showCurrentHunt") {
            var navVC = segue.destinationViewController as! UINavigationController
            var destinationVC = navVC.topViewController as! CurrentHuntViewController
            if let locationsForHunt = locationsForHunt {
                destinationVC.passedLocations = locationsForHunt
            }
        }
    }
}


