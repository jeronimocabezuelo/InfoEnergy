//
//  InfoEnergyTimesView.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 6/8/24.
//

import SwiftUI
import Charts

struct TimesAnnotationView: View {
    let time: Int
    let times: [InfoEnergyTimeItem]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(time.description)
                .font(.headline)
            Divider()
            Text("Valle: \(times.filter({$0.period == .valley}).kWh.toDecimalString())")
            Text("Llano: \(times.filter({$0.period == .flat}).kWh.toDecimalString())")
            Text("Punta: \(times.filter({$0.period == .point}).kWh.toDecimalString())")
            Text("Total: \(times.kWh.toDecimalString())")
        }
        .padding()
        .background(Color.annotationBackground.opacity(0.8))
    }
}

struct InfoEnergyTimesView: View {
    @ObservedObject var model: InfoEnergyModel
    
    @State var times: [InfoEnergyTimeItem] = []
    @State var timesFiltered: [InfoEnergyTimeItem] = []
    @State private var selectedTime: Int?
    
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
                        alignment: .center, spacing: 0
                    ) {
                        TimesAnnotationView(
                            time: selectedTime,
                            times: times
                        )
                    }
            }
        }
        .chartOverlay { (chartProxy: ChartProxy) in
            Color.clear
                .onContinuousHover { hoverPhase in
                    switch hoverPhase {
                    case .active(let hoverLocation):
                        selectedTime = chartProxy.value(
                            atX: hoverLocation.x, as: Int.self
                        )
                    case .ended:
                        selectedTime = nil
                    }
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
