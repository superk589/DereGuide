//
//  DateExtension.swift
//  DereGuide
//
//  Created by zzk on 2017/1/15.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

extension Date {
    
    func toString(format: String = "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone = .tokyo) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format
        
        // If not set this, and in your phone settings select a region that defaults to a 24-hour time, for example "United Kingdom" or "France". Then, disable the "24 hour time" from the settings. Now if you create an NSDateFormatter without setting its locale, "HH" will not work.
        // Reference from https://stackoverflow.com/questions/29374181/nsdateformatter-hh-returning-am-pm-on-ios-8-device
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
    
    func truncateHours(timeZone: TimeZone = .tokyo) -> Date {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = timeZone
        let comps = gregorian.dateComponents([.day, .month, .year], from: self)
        return gregorian.date(from: comps)!
    }
    
    func getElapsedInterval() -> String {
        
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: Bundle.main.preferredLocalizations[0]) // --> IF THE USER HAVE THE PHONE IN SPANISH BUT YOUR APP ONLY SUPPORTS I.E. ENGLISH AND GERMAN WE SHOULD CHANGE THE LOCALE OF THE FORMATTER TO THE PREFERRED ONE (IS THE LOCALE THAT THE USER IS SEEING THE APP), IF NOT, THIS ELAPSED TIME IS GOING TO APPEAR IN SPANISH
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.calendar = calendar
        
        var dateString: String?
        
        let interval = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            formatter.allowedUnits = [.year] // 2 years
        } else if let month = interval.month, month > 0 {
            formatter.allowedUnits = [.month] // 1 month
        } else if let week = interval.weekOfYear, week > 0 {
            formatter.allowedUnits = [.weekOfMonth] // 3 weeks
        } else if let day = interval.day, day > 0 {
            formatter.allowedUnits = [.day] // 6 days
        } else if let hour = interval.hour, hour > 0 {
            formatter.allowedUnits = [.hour]
        } else if let minute = interval.minute, minute > 0 {
            formatter.allowedUnits = [.minute]
        } else if let second = interval.second, second > 0 {
            formatter.allowedUnits = [.second]
        } else {
//            let dateFormatter = DateFormatter()
//            dateFormatter.locale = Locale(identifier: Bundle.main.preferredLocalizations[0]) //--> IF THE USER HAVE THE PHONE IN SPANISH BUT YOUR APP ONLY SUPPORTS I.E. ENGLISH AND GERMAN WE SHOULD CHANGE THE LOCALE OF THE FORMATTER TO THE PREFERRED ONE (IS THE LOCALE THAT THE USER IS SEEING THE APP), IF NOT, THIS ELAPSED TIME IS GOING TO APPEAR IN SPANISH
//            dateFormatter.dateStyle = .medium
//            dateFormatter.doesRelativeDateFormatting = true
//
//            dateString = dateFormatter.string(from: self) // IS GOING TO SHOW 'TODAY'
        }
        
        if dateString == nil {
            dateString = formatter.string(from: self, to: Date())
        }
        
        return dateString!
    }

}
