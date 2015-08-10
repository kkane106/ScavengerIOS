//
//  User.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/10/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

class User : NSManagedObject {
    @NSManaged var username : String
    @NSManaged var id : String
    @NSManaged var email : String
    @NSManaged var updatedAt : NSDate
    @NSManaged var createdAt : NSDate
    @NSManaged var scavengerHunts : NSSet
}