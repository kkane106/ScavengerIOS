//
//  Time.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/18/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import Foundation

struct Time {
    func now() -> String {
        let date = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let defaultTimeZoneStr = formatter.stringFromDate(date)
        formatter.timeZone = NSTimeZone(abbreviation: "UTC")
        let utcTimeZoneStr = formatter.stringFromDate(date)
        
        return utcTimeZoneStr
    }
}