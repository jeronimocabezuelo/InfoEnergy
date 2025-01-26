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
    @State private var selectedTime: Int?
    
    var maxPkWh: Int {
        let maxPkWh = timesFiltered.groupedByTime().map({ $1.pkWh }).max() ?? .zero
        return Int(maxPkWh)
    }
    
    var maxKWh: Int {
        let maxKWh = timesFiltered.groupedByTime().map({ $1.kWh }).max() ?? .zero
        return Int(maxKWh)
    }
    
    var body: some View {
        Chart {
            ForEach(timesFiltered, id: \.id) { item in
                BarMark(
                    x: .value(.timeValue, item.time),
                    y: .value(.kWhValue, item.kWh),
                    width: .inset(10)
                )
                .foregroundStyle(item.period.color)
                .position(by: .value(.periodValue, item.period.rawValue))
                BarMark(
                    x: .value(.timeValue, item.time),
                    y: .value(.pkWhValue, -item.pkWh),
                    width: .inset(10)
                )
                .foregroundStyle(Color.pourColor)
                .position(by: .value(.periodValue, Constants.pourValue))
            }
            
            if let selectedTime, selectedTime.isBetween(0, max: 24) {
                let times = timesFiltered.filter({
                    $0.time == selectedTime
                })
                RectangleMark(x: .value(.timeValue, selectedTime),
                              width: .inset(10))
                    .foregroundStyle(.primary.opacity(0.2))
                    .annotation(
                        position: selectedTime < 12 ? .trailing : .leading,
                        alignment: .center,
                        spacing: 0
                    ) {
                        TimesAnnotationView(
                            time: selectedTime,
                            timeItems: times
                        )
                    }
            }
        }
        .chartOverlay { chart in
            Color.clear
                .onContinuousHover { hoverPhase in
                    switch hoverPhase {
                    case .active(let hoverLocation):
                        selectedTime = chart.value(
                            atX: hoverLocation.x, as: Int.self
                        )
                    case .ended:
                        selectedTime = nil
                    }
                }
        }
        .chartXScale(domain: -1...24)
        .chartYScale(domain: -maxPkWh...maxKWh)
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
                                period: period,
                                pkWh: dateItems.pkWh
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
