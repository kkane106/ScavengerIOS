//
//  ScavengerHuntTableViewCell.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/18/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import UIKit

class ScavengerHuntTableViewCell: UITableViewCell {
    @IBOutlet weak var scavengerHuntName: UILabel!
    @IBOutlet weak var scavengerHuntProximity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
