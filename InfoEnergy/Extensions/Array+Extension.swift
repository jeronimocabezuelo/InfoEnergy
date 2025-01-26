//
//  Array+Extension.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 29/7/24.
//

import Foundation

extension Array where Element == (Period, [InfoEnergyItem]) {
    func addMissingPeriods() -> Self {
        return self.map { (period, items) in
            let dates = Set(items.map(\.date))
            guard let minDate = dates.min(), let maxDate = dates.max() else {
                return (period, items)
            }
            
            var currentDate = minDate
            var updatedItems = items
            
            while currentDate <= maxDate {
                if !dates.contains(currentDate) {
                    updatedItems.append(.init(date: currentDate, kWh: .zero, period: period, pkWh: .zero))
                }
                currentDate = currentDate.byAdding(.day, value: 1)
            }
            
            return (period, updatedItems)
        }
    }
}
