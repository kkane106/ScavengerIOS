//
//  PastHuntsTableViewController.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/19/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import UIKit
import Parse

class PastHuntsTableViewController: UITableViewController {
    
    let cellID = "cellID"
    var userHunts : [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = PFUser.currentUser()
        queryCurrentUserHunts(user!, completion: { (results) -> () in
            self.userHunts = results
            self.tableView.reloadData()
        })
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return userHunts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = userHunts[indexPath.row]["ScavengerHuntId"] as! String

        return cell
    }
    
    func queryCurrentUserHunts(currentUser : PFUser, completion : (results : [PFObject]) -> ()) {
        var query = PFQuery(className: "completedHunt")
        query.whereKey("PlayerId", equalTo: currentUser)
        query.findObjectsInBackgroundWithBlock { (response : [AnyObject]?, error : NSError?) -> Void in
            if error != nil {
                println(error)
            } else {
                if let response = response {
                    println(response)
                    completion(results: response as! [PFObject])
                }
            }
        }
        
    }
}
