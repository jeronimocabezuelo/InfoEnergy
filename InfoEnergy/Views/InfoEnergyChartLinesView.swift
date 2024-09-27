//
//  InfoEnergyChartLinesView.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 29/7/24.
//

import SwiftUI
import Charts

struct LinesAnnotationView: View {
    let date: Date
    let items: [InfoEnergyItem]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(date.formatted(date: .numeric, time: .omitted))
            Divider()
            Text("Valle: \(items.filter({$0.period == .valley}).kWh.toDecimalString())")
            Text("Llano: \(items.filter({$0.period == .flat}).kWh.toDecimalString())")
            Text("Punta: \(items.filter({$0.period == .point}).kWh.toDecimalString())")
            Text("Total: \(items.kWh.toDecimalString())")
        }
        .padding()
        .background(Color.annotationBackground.opacity(0.8))
    }
}

struct InfoEnergyChartLinesView: View {
    var totalItems: [InfoEnergyItem]
    var periodItems: [[InfoEnergyItem]]
    var values: AxisMarkValues
    @State private var selectedDate: Date?
    
    var allItems: [InfoEnergyItem] {
        (totalItems + periodItems.flatMap({ $0 })).sorted()
    }
    
    var startEndDate: (Date, Date)? {
        let allItems = self.allItems
        guard let startDate = allItems.first?.date,
              let endDate = allItems.last?.date
        else { return  nil }
        return (startDate, endDate)
    }
    
    var midDate: Date {
        guard let (startDate, endDate) = startEndDate else { return .now }
        
        let timeInterval = endDate.timeIntervalSince(startDate)
        return startDate.addingTimeInterval(timeInterval / 2)
    }
    
    var body: some View {
        GeometryReader { geometry in
            bodyChart(in: geometry)
                .chartXAxis {
                    axis
                }
                .chartOverlay { chart in
                    overlay(in: chart)
                }
        }
    }
    
    func bodyChart(in geometry: GeometryProxy) -> some View {
        Chart {
            ChartLineView(items: totalItems)
            ChartLineView(items: periodItems.at(0))
            ChartLineView(items: periodItems.at(1))
            ChartLineView(items: periodItems.at(2))
//            ChartBarsView(items: periodItems.at(0))
//            ChartBarsView(items: periodItems.at(1))
//            ChartBarsView(items: periodItems.at(2))
            if let selectedDate {
                let items = periodItems.flatten().filter({ $0.date == selectedDate })
                RectangleMark(x: .value(.dateValue, selectedDate),
                              width: .fixed(dayWidth(in: geometry.size.width) ?? .zero))
                .foregroundStyle(.primary.opacity(0.2))
                .annotation(
                    position: selectedDate < midDate ? .trailing : .leading,
                    alignment: .center, spacing: 0
                ) {
                    LinesAnnotationView(
                        date: selectedDate,
                        items: items
                    )
                }
            }
        }
    }
    
    func dayWidth(in totalWidth: CGFloat) -> CGFloat? {
        guard let (startDate, endDate) = startEndDate
        else { return  nil }
        
        let dates = Calendar.current.daysBetween(from: startDate, to: endDate)
        let result = (1 / CGFloat(dates)) * totalWidth
        return result
    }
    
    var axis: some AxisContent {
        AxisMarks(values: values) { value in
            AxisGridLine()
            AxisValueLabel(collisionResolution: .greedy(minimumSpacing: 0))
        }
    }
    
    func overlay(in chart: ChartProxy) -> some View {
        Color.clear
            .onContinuousHover { hoverPhase in
                switch hoverPhase {
                case .active(let hoverLocation):
                    selectedDate = chart.value(
                        atX: hoverLocation.x, as: Date.self
                    )?.today
                case .ended:
                    selectedDate = nil
                }
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
    var items: [InfoEnergyItem]?
    
    var body: some ChartContent {
        ForEach(items ?? [], id: \.id) { item in
            BarMark(
                x: .value(.dateValue, item.date),
                y: .value(.kWhValue, item.kWh)
            )
            .foregroundStyle(item.period.color)
            .position(by: .value(.periodValue, item.period.rawValue))
        }
    }
}
