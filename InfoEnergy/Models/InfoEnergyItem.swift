//
//  InfoEnergyItem.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 29/7/24.
//

import Foundation

struct InfoEnergyItem: Identifiable {
    let id = UUID()
    
    let date: Date
    let kWh: Float
    let period: Period
}

extension InfoEnergyItem: Comparable {
    static func < (lhs: InfoEnergyItem, rhs: InfoEnergyItem) -> Bool {
        if lhs.date < rhs.date {
            return true
        } else {
            return lhs.period < rhs.period
        }
    }
}

extension Array where Element == InfoEnergyItem {
    static var mock: [InfoEnergyItem] {
        let groupedByDateDataModel = Dictionary(grouping: InfoEnergyCSVModel.mock.items) { item in
            item.date
        }
        return groupedByDateDataModel
            .map { date, items in
                let kWh = items.map({ $0.kWh }).sum()
                return InfoEnergyItem(
                    date: date,
                    kWh: kWh,
                    period: .total
                )
            }
            .sorted()
    }
    
    
    func ranged(by range: Int) -> [InfoEnergyItem] {
        var result = [InfoEnergyItem]()
        for item in self {
            let rangedItems = filter({
                $0.date < item.date &&
                $0.date >= item.date.byAdding(.day, value: -range) })
            let rangedKWh = rangedItems.map({ $0.kWh }).sum()
            let rangedItem = InfoEnergyItem(
                date: item.date,
                kWh: rangedKWh,
                period: item.period
            )
            
            result.append(rangedItem)
        }
        
        return result
    }
}
