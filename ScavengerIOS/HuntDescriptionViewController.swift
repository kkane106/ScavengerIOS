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
    @IBOutlet weak var scavengerHuntNameLabel: UINavigationItem!
    
    var receivedScavengerHunt : PFObject?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func dismissDescription(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        println("dismissed description vc")
        
    }

}
