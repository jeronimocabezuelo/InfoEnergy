//
//  AnnotationView.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 27/9/24.
//

import SwiftUI

struct GenericAnnotationView<Item: InfoEnergyPeriod & InfoEnergyKWh>: View {
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
