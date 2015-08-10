//
//  Location.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/10/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

class Location : NSManagedObject {
    @NSManaged var coordinate : CLLocation
    @NSManaged var clue : String
    @NSManaged var id : String
    @NSManaged var name : String
    @NSManaged var createdAt : NSDate
    @NSManaged var updatedAt : NSDate
    @NSManaged var scavengerHunt : ScavengerHunt
}