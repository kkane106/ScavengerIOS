//
//  ListHuntsViewController.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/3/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import UIKit
import MapKit

class ListHuntsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scavengerHuntsTableView: UITableView!
    
    // This needs to be actual data fetched from the web/core data
/*     
    should be Scavenger Hunt(name, creator, date created, number of locations, average time of
    completion etc...) objects which contain child locations(lat, long, clue, radius, notification/task)
*/
    let proxyCells : [String] = ["one", "two", "three"]
    let newYork : ScavengerHunt = ScavengerHunt(name: "New York", location: CLLocation(latitude: 40.7127, longitude: -74.0059), clue: "it's an apple, some would say that it's big")
    let chicago : ScavengerHunt = ScavengerHunt(name: "Chicago", location: CLLocation(latitude: 41.8369, longitude: -87.6847), clue: "windy city")
    let losAngeles : ScavengerHunt = ScavengerHunt(name: "Los Angeles", location: CLLocation(latitude: 34.0500, longitude: -118.2500), clue: "hollywood")
    let cities : [ScavengerHunt] = [chicago, losAngeles, newYork]

    let cellID = "ScavengerHuntCell"
    var scavengerHuntToPass : ScavengerHunt?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        scavengerHuntsTableView.delegate = self
        scavengerHuntsTableView.dataSource = self
        scavengerHuntsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        scavengerHuntsTableView.reloadData()

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as! UITableViewCell
        cell.textLabel?.text = cities[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow()
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
        
        if let indexPath = indexPath {
            scavengerHuntToPass = cities[indexPath.row] as! ScavengerHunt
        }

        performSegueWithIdentifier("presentCurrentHunt", sender: self)
//        println("Success::\(scavengerHuntToPass.name) \(scavengerHuntToPass.location)")

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "presentCurrentHunt") {
            var destinationVC = segue.destinationViewController as! CurrentHuntViewController
            if let scavengerHuntToPass = scavengerHuntToPass {
                destinationVC.passedValue = scavengerHuntToPass
            }
        }
    }
}
