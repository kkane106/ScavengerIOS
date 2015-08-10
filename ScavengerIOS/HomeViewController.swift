//
//  HomeViewController.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/9/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import UIKit
import Parse
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var userLabel: UILabel!


    
    var currentUser : AnyObject?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: nil)
        
        if let results = fetchedResults {
            currentUser = results
        } else {
            println("something went awry")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("LOOK HERE \(currentUser)")
        
//        var query = PFQuery(className: "ScavengerHunt")
//        query.whereKey("createdBy", equalTo: "kkane")
//        query.findObjectsInBackgroundWithBlock {
//            (result, error) -> Void in
//            if error != nil {
//                println("soemthign went wrong")
//                println(error)
//                println(self.currentUser)
//            } else {
//                println(result)
//            }
//        }
    }

    
}
