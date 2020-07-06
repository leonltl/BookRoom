//
//  NetworkMonitor.swift
//  BookRoom
//
//  The helper class
//  Currently it has only helper method to format to ordinal date
//

import Foundation

public class Utility {
    
    // Uility method to set to ordinal date (1st Jan, 2nd Jan, 3rd Jan and so on)
    public static func ordinalDate(date: Date) -> String {
        let ordinalFormatter = NumberFormatter()
        ordinalFormatter.numberStyle = .ordinal
        let day = Calendar.current.component(.day, from: date)
        let dayOrdinal = ordinalFormatter.string(from: NSNumber(value: day))!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "'\(dayOrdinal)' MMM yyyy"
        return dateFormatter.string(from: Date())
    }
}
