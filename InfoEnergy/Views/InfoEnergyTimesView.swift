//
//  InfoEnergyTimesView.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 6/8/24.
//

import SwiftUI
import Charts

struct InfoEnergyTimesView: View {
    @ObservedObject var model: InfoEnergyModel
    
    @State var times: [InfoEnergyTimeItem] = []
    @State var timesFiltered: [InfoEnergyTimeItem] = []
    
    var body: some View {
        Chart {
            ForEach(timesFiltered, id: \.id) { item in
                BarMark(
                    x: .value(.dateValue, item.time),
                    y: .value(.kWhValue, item.kWh),
                    width: .inset(10)
                )
                .foregroundStyle(item.period.color)
                .position(by: .value(.periodValue, item.period.rawValue))
            }
        }
        .chartXScale(domain: -1...24)
        .chartXAxis {
            AxisMarks(preset: .aligned, values: .stride(by: 1)) { value in
                if (0...23).contains(value.as(Int.self) ?? -1) {
                    AxisValueLabel(anchor: .top)
                }
            }
        }
        .onChange(of: model.startDate, reloadFilterTimes)
        .onChange(of: model.endDate, reloadFilterTimes)
        .onAppear {
            reloadTimes()
        }
        .onReceive(model.$rawDataModel) { _ in
            reloadTimes()
        }
    }
    
    func reloadTimes() {
        times = model.rawDataModel.items.groupedByTime()
            .flatMap({ time, items in
                items.groupedByPeriod()
                    .flatMap({ period, periodItems in
                        periodItems.groupedByDate().map({ (date, dateItems) in
                            InfoEnergyTimeItem(
                                date: date,
                                time: time,
                                kWh: dateItems.kWh,
                                period: period
                            )
                        })
                    })
                
            })
            .sorted()
        
        reloadFilterTimes()
    }
    
    func reloadFilterTimes() {
        timesFiltered = times.filter(model.startDate, model.endDate)
    }
}
