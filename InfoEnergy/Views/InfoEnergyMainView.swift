//
//  InfoEnergyMainView.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 29/7/24.
//

import SwiftUI

struct InfoEnergyMainView: View {
    @ObservedObject var model = InfoEnergyModel()
    
    var body: some View {
        VStack {
            HStack {
                FilterDateView(startDate: $model.startDate, endDate: $model.endDate)
                Spacer()
                Stepper(
                    "Groping \(model.range) days",
                    value: $model.range,
                    in: 1...1000
                )
                ImportButton(onLoadDocument: onLoadDocument)
            }
            
            Legend()
            
            InfoEnergyLinesView(model: model)
            Spacer(minLength: 16)
            InfoEnergyTimesView(model: model)
        }
        .padding(16)
    }
    
    func onLoadDocument(_ newDocument: String) {
        let csvModel = InfoEnergyCSVModel(document: newDocument)
        
        self.model.rawDataModel = csvModel
        self.model.startDate = csvModel.items.first?.date ?? .now
        self.model.endDate = csvModel.items.last?.date ?? .now
    }
}

#Preview {
    InfoEnergyMainView()
}
