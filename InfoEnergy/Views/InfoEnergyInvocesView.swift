//
//  InfoEnergyInvocesView.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 29/1/25.
//

import SwiftUI
import Charts

struct InfoEnergyInvocesView: View {
    @ObservedObject var model: InfoEnergyModel
    @State var invoces: [InvoceData] = []
    
    var body: some View {
        VStack {
            InvoceImporterButtonView(onLoadInvoce: onLoadInvoce)
            InfoEnergyInvoceChart(invoces: invoces, dataModel: model.rawDataModel)
        }
        .onAppear {
            print("onAppear \(Self.self)")
            reloadInvoces()
        }
    }
    
    func onLoadInvoce(_ invoice: InvoceData) {
        UserManager.shared.saveInvoces?.append(invoice)
        reloadInvoces()
    }
    
    func reloadInvoces() {
        if UserManager.shared.saveInvoces == nil {
            UserManager.shared.saveInvoces = []
        }
        
        UserManager.shared.saveInvoces?.removeAll(where: { $0.energy.isEmpty && $0.energyGeneration.isEmpty })
        
        self.invoces = UserManager.shared.saveInvoces?.sorted(by: { $0.start ?? .distantPast < $1.start ?? .distantPast}) ?? []
    }
}

struct InfoEnergyInvoceChart: View {
    let invoces: [InvoceData]
    let dataModel: InfoEnergyCSVModel
    
    @State var selectedInvoceXValue: String?
    
    var selectedInvoce: InvoceData? {
        invoces.first(where: {
            $0.period?.plotableValue == selectedInvoceXValue
        })
    }
    
    var selectedInvocePosition: AnnotationPosition {
        guard let selectedInvoceIndex = invoces.firstIndex(where: {
            $0.period?.plotableValue == selectedInvoceXValue
        }) else { return .automatic }
        
        return selectedInvoceIndex < (invoces.count / 2) ? .trailing : .leading
    }
    
    var maxKWh: Int {
        let maxKWh = invoces.compactMap({ [$0.valleyUse, $0.flatUse, $0.pointUse].max() }).max() ?? .zero
        return Int(maxKWh)
    }
    
    func overlay(in chart: ChartProxy) -> some View {
        Color.clear
            .onContinuousHover { hoverPhase in
                switch hoverPhase {
                case .active(let hoverLocation):
                    selectedInvoceXValue = chart.value(
                        atX: hoverLocation.x, as: String.self
                    )
                case .ended:
                    selectedInvoceXValue = nil
                }
            }
    }
    
    var body: some View {
        Chart {
            ForEach(invoces) { invoce in
                // Generation
                BarMark(
                    x: .value("period", invoce.period?.plotableValue ?? ""),
                    y: .value("use", Double(invoce.energyGeneration.valleyUse))
                )
                .foregroundStyle(Period.valley.generationColor)
                .position(by: .value("period", "valley"))
                BarMark(
                    x: .value("period", invoce.period?.plotableValue ?? ""),
                    y: .value("use", Double(invoce.energyGeneration.pointUse))
                )
                .foregroundStyle(Period.point.generationColor)
                .position(by: .value("period", "point"))
                BarMark(
                    x: .value("period", invoce.period?.plotableValue ?? ""),
                    y: .value("use", Double(invoce.energyGeneration.flatUse))
                )
                .foregroundStyle(Period.flat.generationColor)
                .position(by: .value("period", "flat"))
                // Energy
                BarMark(
                    x: .value("period", invoce.period?.plotableValue ?? ""),
                    y: .value("use", Double(invoce.energy.valleyUse))
                )
                .foregroundStyle(Period.valley.color)
                .position(by: .value("period", "valley"))
                BarMark(
                    x: .value("period", invoce.period?.plotableValue ?? ""),
                    y: .value("use", Double(invoce.energy.pointUse))
                )
                .foregroundStyle(Period.point.color)
                .position(by: .value("period", "point"))
                BarMark(
                    x: .value("period", invoce.period?.plotableValue ?? ""),
                    y: .value("use", Double(invoce.energy.flatUse))
                )
                .foregroundStyle(Period.flat.color)
                .position(by: .value("period", "flat"))
            }
            
            if let selectedInvoce {
                RectangleMark(
                    x: .value("period", selectedInvoce.period?.plotableValue ?? "")
                )
                .foregroundStyle(.primary.opacity(0.2))
                .annotation(
                    position: selectedInvocePosition,
                    alignment: .center,
                    spacing: 0
                ) {
                    let items = dataModel.items.filter(selectedInvoce.start, selectedInvoce.end)
                    
                    InvoceAnnotationView(invoice: selectedInvoce, energyItems: items)
                }
            }
        }
        .chartYScale(domain: 0...maxKWh)
        .chartOverlay { chart in
            overlay(in: chart)
        }
        
    }
}

// MARK: Descartes
struct InvoceView: View {
    var invoce: InvoceData
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(invoce.start?.formatted(date: .numeric, time: .omitted) ?? "")
                Text(invoce.end?.formatted(date: .numeric, time: .omitted) ?? "")
            }
            .font(.title2)
            Text("Periodos energía:")
                .font(.title3)
            ForEach(invoce.energy) { item in
                InvoceItemView(item: item)
            }
            Text("Periodos Generation:")
                .font(.title3)
            ForEach(invoce.energyGeneration) { item in
                InvoceItemView(item: item)
            }
        }
    }
}

struct InvoceItemView: View {
    var item: InvoceItemData
    
    var body: some View {
        Grid(alignment: .leading) {
            GridRow {
                HStack {
                    Text(item.period.start.formatted(date: .numeric, time: .omitted))
                    Text(item.period.end.formatted(date: .numeric, time: .omitted))
                }
                Text("Punta")
                Text("Llano")
                Text("Valle")
            }
            GridRow {
                Text("Uso")
                Text(item.pointUse.formatted())
                Text(item.flatUse.formatted())
                Text(item.valleyUse.formatted())
            }
            GridRow {
                Text("Precio")
                Text(item.pointPrice.formatted())
                Text(item.flatPrice.formatted())
                Text(item.valleyPrice.formatted())
            }
            GridRow {
                Text("Total")
                Text(item.pointTotal.formatted())
                Text(item.flatTotal.formatted())
                Text(item.valleyTotal.formatted())
            }
        }
    }
}
