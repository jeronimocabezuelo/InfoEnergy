//
//  AnnotationView.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 27/9/24.
//

import SwiftUI

struct GenericAnnotationView<Item: InfoEnergyPeriod & InfoEnergyKWh & InfoEnergyPKWh>: View {
    let title: any StringProtocol
    let items: [Item]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            Divider()
            Text("Valle: \(items.filter({$0.period == .valley}).kWh.toDecimalString())")
            Text("Llano: \(items.filter({$0.period == .flat}).kWh.toDecimalString())")
            Text("Punta: \(items.filter({$0.period == .point}).kWh.toDecimalString())")
            Text("Total: \(items.kWh.toDecimalString())")
            Text("Vertido: \(items.pkWh.toDecimalString())")
        }
        .padding()
        .background(Color.annotationBackground.opacity(0.8))
    }
}

struct TimesAnnotationView: View {
    let time: Int
    let timeItems: [InfoEnergyTimeItem]
    
    var body: some View {
        GenericAnnotationView(
            title: time.description,
            items: timeItems
        )
    }
}

struct LinesAnnotationView: View {
    let date: Date
    let items: [InfoEnergyItem]
    
    var body: some View {
        GenericAnnotationView(
            title: date.formatted(date: .numeric, time: .omitted),
            items: items
        )
    }
}

struct InvoceAnnotationView: View {
    let invoice: InvoceData
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(invoice.period?.plotableValue ?? "")
                .font(.headline)
            Divider()
            if invoice.energy.isNotEmpty {
                VStack(alignment: .leading) {
                    Text("Energía utilizada")
                    Text("Valle: \(invoice.energy.valleyUse.toDecimalString())")
                    Text("Llano: \(invoice.energy.flatUse.toDecimalString())")
                    Text("Punta: \(invoice.energy.pointUse.toDecimalString())")
                    Text("Energía utilizada Total: \(invoice.energy.use.toDecimalString())")
                }
            }
            Divider()
            if invoice.energyGeneration.isNotEmpty {
                VStack(alignment: .leading) {
                    Text("Energía GenerationkWh utilizada")
                    Text("Valle: \(invoice.energyGeneration.valleyUse.toDecimalString())")
                    Text("Llano: \(invoice.energyGeneration.flatUse.toDecimalString())")
                    Text("Punta: \(invoice.energyGeneration.pointUse.toDecimalString())")
                    Text("GenerationkWhTotal: \(invoice.energyGeneration.use.toDecimalString())")
                    Text("Ahorro con GenerationkWh: \(invoice.savings.toDecimalString())€")
                }
                Divider()
            }
            Text("Total: \(invoice.use.toDecimalString())")
        }
        .padding()
        .background(Color.annotationBackground.opacity(0.8))
    }
}
