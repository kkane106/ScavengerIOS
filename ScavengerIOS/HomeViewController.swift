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
    
    @IBAction func doSignOut(sender: UIBarButtonItem) {
        PFUser.logOut()
        println("current user: \(PFUser.currentUser())")
        presentLoginVC()
        
    }
    
//    func getSavedData(completion: (data: PFObject) -> ()) {
//        let query = PFQuery(className: "ScavengerHunt")
//        let results = query.getFirstObject()
//        if let results = results {
//            completion(data: results)
//        }
//    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "logoutSegueView") {
            var navigationVC = segue.destinationViewController as! UINavigationController
            var loginVC = navigationVC.topViewController
            
        }
    }
    
    func presentLoginVC() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
        let navigationVC = UINavigationController(rootViewController: vc)
        self.presentViewController(navigationVC, animated: true, completion: nil)
    }
    
    
}
