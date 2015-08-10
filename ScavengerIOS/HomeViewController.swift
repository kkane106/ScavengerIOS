//
//  HomeViewController.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/9/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {

    var passedValue : PFUser?
    
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let passedValue = passedValue {
            userLabel.text = passedValue.email
        } else {
            userLabel.text = "nothing"
        }
        // Do any additional setup after loading the view.
    }

    
}
