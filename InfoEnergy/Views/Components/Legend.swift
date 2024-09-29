//
//  Legend.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 5/8/24.
//

import SwiftUI
import DeveloperKit

struct PeriodLegend: View {
    let period: Period
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(period.color)
                .frame(width: 24, height: 24)
                .clipShape(.rect(cornerRadius: 4))
            Text(period.title)
        }
    }
}

struct Legend: View {
    @Binding var hoveredPeriod: Period?
    
    @State private var hoverStates: [Period: Bool] = [
        .valley: false,
        .flat: false,
        .point: false,
        .total: false
    ]
    
    func hover(period: Period) -> Binding<Bool> {
        return Binding<Bool>(
            get: {
                self.hoverStates[period] ?? false
            },
            set: { newValue in
                self.hoverStates[period] = newValue
                self.hoveredPeriod = newValue ? period : nil
            }
        )
    }
    
    var body: some View {
        HStack {
            DividedForEach(Period.allCases, id: \.self) { period in
                HoverView(hover: hover(period: period)) {
                    PeriodLegend(period: period)
                }
            } divider: {
                Spacer()
            }
        }
    }
}
