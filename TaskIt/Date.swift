//
//  Date.swift
//  TaskIt
//
//  Created by Diego Guajardo on 11/02/2015.
//  Copyright (c) 2015 GuajasDev. All rights reserved.
//

import Foundation

class Date {
    
    // The hash before 'year' makes year appear when we call a function (ie Date.from(year: 3, ...) instead of Date.from(3, ...)
    class func from(#year: Int, month: Int, day: Int) -> NSDate {
        var components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        var gregorianCalendar = NSCalendar(identifier: NSGregorianCalendar)!
        var date = gregorianCalendar.dateFromComponents(components)
        
        return date!
    }
    
    // Changes an NSDate instance to a String instance
    class func toString(#date:NSDate) -> String {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateStringFormatter.stringFromDate(date)
        
        return dateString
    }
    
}