//
//  ScavengerHunt.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/3/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class ScavengerHunt : NSManagedObject {
    @NSManaged var name : String
    @NSManaged var locations : NSSet
    @NSManaged var updatedAt : NSDate
    @NSManaged var createdAt : NSDate
    @NSManaged var id : String
    
}