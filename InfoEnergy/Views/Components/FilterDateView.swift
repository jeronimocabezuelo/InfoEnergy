//
//  FilterDateView.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 3/8/24.
//

import SwiftUI

struct FilterDateView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    var body: some View {
        HStack{
            DatePicker(
                "Start Date",
                selection: $startDate,
                displayedComponents: [.date]
            )
            DatePicker(
                "End Date",
                selection: $endDate,
                displayedComponents: [.date]
            )
        }
    }
}

#Preview {
    FilterDateView(startDate: .constant(.now), endDate: .constant(.now.addingTimeInterval(3600*24*2)))
}
