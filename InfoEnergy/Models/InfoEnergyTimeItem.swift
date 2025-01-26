//
//  InfoEnergyTimeItem.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 6/8/24.
//

import Foundation

struct InfoEnergyTimeItem: Identifiable, InfoEnergyDate, InfoEnergyTime, InfoEnergyKWh, InfoEnergyPeriod, InfoEnergyPKWh {
    let id = UUID()
    
    let date: Date
    let time: Int
    let kWh: Float
    let period: Period
    let pkWh: Float
}

extension InfoEnergyTimeItem: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.period < rhs.period
    }
}
