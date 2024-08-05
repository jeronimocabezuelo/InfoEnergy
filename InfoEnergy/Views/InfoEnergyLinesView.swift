//
//  InfoEnergyLinesView.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 3/8/24.
//

import SwiftUI

class InfoEnergyModel: ObservableObject {
    @Published var startDate: Date = InfoEnergyCSVModel.mock.items.first?.date ?? .now
    @Published var endDate: Date = InfoEnergyCSVModel.mock.items.last?.date ?? .now
    @Published var range: Int = 7
    @Published var rawDataModel: InfoEnergyCSVModel = .mock
}


struct InfoEnergyLinesView: View {
    @ObservedObject var model: InfoEnergyModel
    
    @State var totalItems: [InfoEnergyItem] = []
    @State var totalItemsRanged: [InfoEnergyItem] = []
    @State var totalItemsFiltered: [InfoEnergyItem] = []
    
    @State var periodItems: [[InfoEnergyItem]] = []
    @State var periodItemsRanged: [[InfoEnergyItem]] = []
    @State var periodItemsFiltered: [[InfoEnergyItem]] = []
    
    var body: some View {
        InfoEnergyChartLinesView(totalItems: totalItemsFiltered, periodItems: periodItemsFiltered)
            .onChange(of: model.range, reloadRangeItems)
            .onChange(of: model.startDate, reloadFilterItems)
            .onChange(of: model.endDate, reloadFilterItems)
            .onAppear {
                reloadItems()
            }
            .onReceive(model.$rawDataModel) { _ in
                reloadItems()
            }
    }
    
    func reloadItems() {
        let groupedByDateDataModel = Dictionary(grouping: model.rawDataModel.items) { item in
            item.date
        }
        totalItems = groupedByDateDataModel
            .map { date, items in
                let kWh = items.map({ $0.kWh }).sum()
                return InfoEnergyItem(
                    date: date,
                    kWh: kWh,
                    period: .total
                )
            }
            .sorted()
        let barsItems = groupedByDateDataModel
            .flatMap { date, items in
                let groupedByPeriod = Dictionary(grouping: items) { item in
                    item.period
                }
                
                return groupedByPeriod.map { period, periodItems in
                    let kWh = periodItems.map({ $0.kWh }).sum()
                    return InfoEnergyItem(
                        date: date,
                        kWh: kWh,
                        period: period
                    )
                }
                
            }
            .sorted()
        
        
        periodItems = Dictionary(grouping: barsItems) { item in
            item.period
        }.map({ $1.sorted() })
        
        reloadRangeItems()
    }
    
    func reloadRangeItems() {
        
        totalItemsRanged = totalItems.ranged(by: model.range)
        periodItemsRanged = periodItems.map({ $0.ranged(by: model.range) })
        
        reloadFilterItems()
    }
    
    func reloadFilterItems() {
        totalItemsFiltered = totalItemsRanged.filter({ model.startDate < $0.date && $0.date < model.endDate})
        periodItemsFiltered = periodItemsRanged.map({ $0.filter({ model.startDate < $0.date && $0.date < model.endDate }) })
    }
}
