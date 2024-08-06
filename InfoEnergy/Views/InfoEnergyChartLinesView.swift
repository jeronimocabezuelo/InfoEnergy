//
//  InfoEnergyChartLinesView.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 29/7/24.
//

import SwiftUI
import Charts

struct InfoEnergyChartLinesView: View {
    var totalItems: [InfoEnergyItem]
    var periodItems: [[InfoEnergyItem]]
    
    var body: some View {
        Chart {
            ChartLineView(items: totalItems)
            ChartLineView(items: periodItems.at(0))
            ChartLineView(items: periodItems.at(1))
            ChartLineView(items: periodItems.at(2))
        }
    }
}

struct ChartLineView: ChartContent {
    var items: [InfoEnergyItem]?
    
    var body: some ChartContent {
        ForEach(items ?? [], id: \.id) { item in
            LineMark(
                x: .value(.dateValue, item.date),
                y: .value(.kWhValue, item.kWh),
                series: .value(.periodValue, item.period.rawValue)
            )
            .position(by: .value(.periodValue, item.period.rawValue))
            .foregroundStyle(item.period.color)
        }
    }
}

struct ChartBarsView: ChartContent {
    var items: [InfoEnergyItem]
    
    var body: some ChartContent {
        ForEach(items, id: \.id) { item in
            BarMark(
                x: .value(.dateValue, item.date),
                y: .value(.kWhValue, item.kWh)
            )
            .foregroundStyle(item.period.color)
            .position(by: .value(.periodValue, item.period.rawValue))
        }
    }
}

extension LocalizedStringKey {
    static var dateValue: LocalizedStringKey = "Date"
    static var kWhValue: LocalizedStringKey = "kWh"
    static var periodValue: LocalizedStringKey = "period"
}
