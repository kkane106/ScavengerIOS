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
