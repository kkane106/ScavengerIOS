//
//  ScavengerHunt.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/3/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import Foundation
import MapKit

class ScavengerHunt {
    let name : String
    let location : CLLocation
    let clue : String
    
    init(name : String, location : CLLocation, clue : String) {
        self.name = name
        self.location = location
        self.clue = clue
    }
}