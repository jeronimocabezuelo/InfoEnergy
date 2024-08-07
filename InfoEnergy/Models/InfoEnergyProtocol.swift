//
//  InfoEnergyProtocol.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 7/8/24.
//

import Foundation

protocol InfoEnergyDate {
    var date: Date { get }
}

extension Array where Element: InfoEnergyDate {
    func groupedByDate() -> [(Date, Self)] {
        grouped(by: { $0.date })
    }
    
    func filter(_ startDate: Date, _ endDate: Date) -> Self {
        filter({ $0.date.isBetween(startDate, endDate) })
    }
}

protocol InfoEnergyPeriod {
    var period: Period { get }
}

extension Array where Element: InfoEnergyPeriod {
    func groupedByPeriod() -> [(Period, Self)] {
        grouped(by: { $0.period })
    }
}

protocol InfoEnergyTime {
    var time: Int { get }
}

extension Array where Element: InfoEnergyTime {
    func groupedByTime() -> [(Int, Self)] {
        grouped(by: { $0.time })
    }
}

protocol InfoEnergyKWh {
    var kWh: Float { get }
}

extension Array where Element: InfoEnergyKWh {
    var kWh: Float {
        map({ $0.kWh }).sum()
    }
}
