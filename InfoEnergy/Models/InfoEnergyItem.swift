//
//  InfoEnergyItem.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 29/7/24.
//

import Foundation

struct InfoEnergyItem: Identifiable, InfoEnergyDate, InfoEnergyKWh, InfoEnergyPeriod, InfoEnergyPKWh {
    let id = UUID()
    
    let date: Date
    let kWh: Float
    let period: Period
    let pkWh: Float
}

extension InfoEnergyItem: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.date < rhs.date {
            return true
        } else {
            return lhs.period < rhs.period
        }
    }
}

extension Array where Element == InfoEnergyItem {
    static var mock: Self {
        let groupedByDateDataModel = InfoEnergyCSVModel.mock.items.groupedByDate()
        return groupedByDateDataModel
            .map { date, items in
                return InfoEnergyItem(
                    date: date,
                    kWh: items.kWh,
                    period: .total,
                    pkWh: items.pkWh
                )
            }
            .sorted()
    }
    
    func ranged(by range: Int) -> Self {
        var result = [InfoEnergyItem]()
        for item in self {
            let rangedItems = filter({
                $0.date < item.date &&
                $0.date >= item.date.byAdding(.day, value: -range) })
            let rangedItem = InfoEnergyItem(
                date: item.date,
                kWh: rangedItems.kWh,
                period: item.period,
                pkWh: rangedItems.pkWh
            )
            
            result.append(rangedItem)
        }
        
        return result
    }
}
