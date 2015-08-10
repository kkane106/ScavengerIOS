//
//  ListHuntsViewController.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/3/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import UIKit
import MapKit
import Parse

class ListHuntsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scavengerHuntsTableView: UITableView!

    let cellID = "ScavengerHuntCell"
    var scavengerHuntToPass : PFObject?
    
    var scavengerHunts = [PFObject]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        updateScavengerHunts(UIRefreshControl())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scavengerHuntsTableView.delegate = self
        scavengerHuntsTableView.dataSource = self
        scavengerHuntsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        scavengerHuntsTableView.reloadData()

    }
    
    func updateScavengerHunts(sender: UIRefreshControl) {
        var query = PFQuery(className: "ScavengerHunt")
        query.orderByDescending("updatedAt")
        query.findObjectsInBackgroundWithBlock {
            (response, error) -> Void in
            if error != nil {
                println("didn't work")
                return
            }
            
            if let response = response {
                self.scavengerHunts = response as! [PFObject]
                println("RESPONSE AS LIST OF SCAVENGER HUNTS: \(response)")
            }
            sender.endRefreshing()
            self.scavengerHuntsTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as! UITableViewCell
        let currentHunt = scavengerHunts[indexPath.row]
        cell.textLabel?.text = currentHunt["name"] as! String
        
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
        performSegueWithIdentifier("presentCurrentHunt", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "presentCurrentHunt") {
            var navigationVC = segue.destinationViewController as! UINavigationController
            var destinationVC = navigationVC.topViewController as! CurrentHuntViewController
            if let scavengerHuntToPass = scavengerHuntToPass {
                destinationVC.passedValue = scavengerHuntToPass
            }
        }
    }
}
