//
//  InfoEnergyCSVModel.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 29/7/24.
//

import Foundation

struct InfoEnergyCSVModel {
    let items: [InfoEnergyCSVItemModel]
}

extension InfoEnergyCSVModel: Equatable {
    static func == (lhs: InfoEnergyCSVModel, rhs: InfoEnergyCSVModel) -> Bool {
        guard lhs.items.count == rhs.items.count else { return false}
        
        for index in 0..<lhs.items.count {
            let lhs = lhs.items.at(index)
            let rhs = rhs.items.at(index)
            if lhs != rhs {
                return false
            }
        }
        
        return true
    }
}

extension InfoEnergyCSVModel {
    static var mock: Self {
        let mock = Self.init(document: InputDocument.mock.input)
        
        let mockShort = Self.init(items: Array(mock.items.prefix(24*30)))
        return mockShort
    }
    
    init(document: String) {
        self.items = document
            .components(separatedBy: "\n")
            .compactMap({
                InfoEnergyCSVItemModel(documentRow: $0)
            })
    }
}

struct InfoEnergyCSVItemModel {
    let cups: String
    let date: Date
    let time: Int
    let kWh: Float
    
    var period: Period {
        let calendar = Calendar.current
        
        if calendar.isDateInWeekend(date) {
            return .valley
        }
        
        if calendar.isDateInNationalHoliday(date) {
            return .valley
        }
        
        return time.period
    }
}

extension InfoEnergyCSVItemModel: Equatable {
    
}

extension InfoEnergyCSVItemModel {
    init?(documentRow: String) {
        var documentRow = documentRow
        documentRow.removeFirst()
        documentRow.removeLast()
        
        let infoRow = documentRow.components(separatedBy: "\",\"")
        guard let cups = infoRow.at(0),
              let dateString = infoRow.at(1),
              let timeString = infoRow.at(2),
              let kWhString = infoRow.at(3)?.replacingOccurrences(of: ",", with: "."),
              let date = dateString.createDate(),
              let time = Int(timeString),
              let kWh = Float(kWhString)
        else { return nil }
        self.cups = cups
        self.date = date
        self.time = time
        self.kWh = kWh
    }
}
