//: Playground - noun: a place where people can play
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

var time = Time()
time.now()
var nope = Time()
nope.now()
nope.now()

