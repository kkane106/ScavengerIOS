//: Playground - noun: a place where people can play
import Foundation

struct elapsedTime {
    
    var startTime : String
    var endTime : String
    
    func convertStringsToSeconds() -> [String : Int] {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let startDateStr = startTime
        let startDate : NSDate = dateFormatter.dateFromString(startDateStr)!
        
        let endDateStr = endTime
        let endDate : NSDate = dateFormatter.dateFromString(endDateStr)!
        let dateComponents: NSDateComponents = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.components(NSCalendarUnit.CalendarUnitSecond, fromDate: startDate, toDate: endDate, options: NSCalendarOptions(0))
        
        let secondsElapsed = dateComponents.second
        
        var convertedTime = [String : Int]()
        convertedTime["seconds"] = secondsElapsed % 60
        convertedTime["minutes"] = (secondsElapsed / 60) % 60
        convertedTime["hours"] = (secondsElapsed / 3600) % 24
        convertedTime["days"] = (secondsElapsed / 3600) / 24
        
        return convertedTime
    }
}


var x = elapsedTime(startTime: "2015-08-18 22:34:21", endTime: "2015-08-19 23:21:03")
var y = x.convertStringsToSeconds()
y["days"]
y["hours"]
y["minutes"]
y["seconds"]

var z = [0]
z
z.append(2)
z
z.append(3)
z


