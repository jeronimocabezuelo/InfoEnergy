//
//  InfoEnergyLinesView.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 3/8/24.
//

import SwiftUI

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
        let groupedByDateDataModel = model.rawDataModel.items.groupedByDate()
        totalItems = groupedByDateDataModel
            .map { date, items in
                InfoEnergyItem(
                    date: date,
                    kWh: items.kWh,
                    period: .total
                )
            }
            .sorted()
        let barsItems = groupedByDateDataModel
            .flatMap { date, items in
                let groupedByPeriod = items.groupedByPeriod()
                
                return groupedByPeriod.map { period, periodItems in
                    InfoEnergyItem(
                        date: date,
                        kWh: periodItems.kWh,
                        period: period
                    )
                }
                
            }
            .sorted()
        
        periodItems = barsItems.groupedByPeriod()
            .map({ $1.sorted() })
        
        reloadRangeItems()
    }
    
    func reloadRangeItems() {
        totalItemsRanged = totalItems.ranged(by: model.range)
        periodItemsRanged = periodItems.map({ $0.ranged(by: model.range) })
        
        reloadFilterItems()
    }
    
    func reloadFilterItems() {
        totalItemsFiltered = totalItemsRanged.filter(model.startDate, model.endDate)
        periodItemsFiltered = periodItemsRanged.map({ $0.filter(model.startDate, model.endDate)})
    }
}
