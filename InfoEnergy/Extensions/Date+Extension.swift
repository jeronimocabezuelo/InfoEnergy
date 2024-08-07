//
//  Date+Extension.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 29/7/24.
//

import Foundation

extension Date {
    func byAdding(_ component: Calendar.Component,
                  value: Int,
                  calendar: Calendar = .current) -> Date {
        return calendar.date(
            byAdding: component,
            value: value,
            to: self
        ) ?? self
    }
    
    func isBetween(_ startDate: Date, _ endDate: Date) -> Bool {
        return startDate < self && self < endDate
    }
}
