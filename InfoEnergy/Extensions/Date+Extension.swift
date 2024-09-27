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
    
    var today: Date? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: self)
        
        guard let noon = calendar.date(byAdding: .hour, value: 12, to: startOfDay) else { return nil }
        // Si la hora actual es después de las 12:00 PM, devolver el inicio del siguiente día
        if self > noon {
            return calendar.date(byAdding: .day, value: 1, to: startOfDay)
        } else {
            return startOfDay
        }
    }
    
    func isBetween(_ startDate: Date, _ endDate: Date) -> Bool {
        return startDate < self && self < endDate
    }
}
