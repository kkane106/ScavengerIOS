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
    
    var users : [NSManagedObject]?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"User")
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            users = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        if let users = users {
            println(users[0].valueForKey("username"))
            println(users.count)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getSavedData { (data) -> () in
//            println("Here is data: \(data)")
//        }


    }
    
//    func getSavedData(completion: (data: PFObject) -> ()) {
//        let query = PFQuery(className: "ScavengerHunt")
//        let results = query.getFirstObject()
//        if let results = results {
//            completion(data: results)
//        }
//    }

    
}
