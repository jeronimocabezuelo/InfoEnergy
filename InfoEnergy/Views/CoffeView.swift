//
//  CoffeView.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 29/7/24.
//

import SwiftUI
import Charts

enum Coffee {
    case one, two
}

struct CoffeeData: Identifiable {
    typealias CoffeeDetails = (type: Coffee, amount: Int)
    let id = UUID()
    let date: Date
    let details: [CoffeeDetails]
    
    static func mockData() -> [CoffeeData] {
        return [CoffeeData(date: .init(timeIntervalSinceNow: 100000), details: [(.one, 100)]), CoffeeData(date: .init(timeIntervalSinceNow: 1000000), details: [(.one, 100)])]
    }
}

struct CoffeView: View {
    
    @State private var coffeeData = CoffeeData.mockData()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Chart {
                ForEach(coffeeData, id: \.id) { coffeeInfo in
                    LineMark(
                        x: .value("Date", coffeeInfo.date),
                        y: .value("Coffee", totalCoffees(in: coffeeInfo.details))
                    )
                }
            }
            .frame(height: 300)
            .padding()
        }
        .padding()
    }
    
    func totalCoffees(in details: [CoffeeData.CoffeeDetails]) -> Int {
        return details.map({$0.amount}).reduce(0, +)
    }
}

#Preview {
    CoffeView()
}
