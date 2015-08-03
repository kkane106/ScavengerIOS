//
//  ListHuntsViewController.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/3/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import UIKit

class ListHuntsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scavengerHuntsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}
