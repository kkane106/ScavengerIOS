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

struct ElapsedTime {
    
    var startTime : String
    var endTime : String
    
    func convertStringsToSeconds() -> [Int] {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let startDateStr = startTime
        let startDate : NSDate = dateFormatter.dateFromString(startDateStr)!
        
        let endDateStr = endTime
        let endDate : NSDate = dateFormatter.dateFromString(endDateStr)!
        let dateComponents: NSDateComponents = NSCalendar(
                calendarIdentifier: NSCalendarIdentifierGregorian)!.components(NSCalendarUnit.CalendarUnitSecond,
                fromDate: startDate,
                toDate: endDate,
                options: NSCalendarOptions(0)
        )
        
        let secondsElapsed = dateComponents.second
        
        var convertedTime = [Int]()
        convertedTime.append(secondsElapsed % 60)
        convertedTime.append((secondsElapsed / 60) % 60)
        convertedTime.append((secondsElapsed / 3600) % 24)
        convertedTime.append((secondsElapsed / 3600) / 24)
        
        return convertedTime
    }
}