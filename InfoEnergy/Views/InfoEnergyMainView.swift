//
//  InfoEnergyMainView.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 29/7/24.
//

import SwiftUI
import DeveloperKit

struct InfoEnergyMainView: View {
    @ObservedObject var model = InfoEnergyModel()
    
    var body: some View {
        ZStack {
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
                    Button {
                        UserManager.shared.saveCVSModel = nil
                        model.update(with: nil)
                    } label: {
                        Text("Reset")
                    }
                }
                
                Legend(hoveredPeriod: $model.hoveredPeriod)
                VStack(alignment: .leading) {
                    Button {
                        model.showLines.toggle()
                    } label: {
                        Text("Lines \(model.showLines ? "🔼" : "🔽")")
                    }
                    if model.showLines { InfoEnergyLinesView(model: model) }
                    
                    Spacer(minLength: 16)
                    
                    Button {
                        model.showBars.toggle()
                    } label: {
                        Text("Bars \(model.showBars ? "🔼" : "🔽")")
                    }
                    if model.showBars { InfoEnergyTimesView(model: model) }
                    
                    Spacer(minLength: 16)
                    
                    Button {
                        model.showInvoces.toggle()
                    } label: {
                        Text("Invoces \(model.showInvoces ? "🔼" : "🔽")")
                    }
                    if model.showInvoces { InfoEnergyInvocesView() }
                }
            }
            .padding(16)
            
            if let hoveredPeriod = model.hoveredPeriod {
                ClockView(period: hoveredPeriod)
            }
        }
        .onAppear {
            let storedModel = UserManager.shared.saveCVSModel 
            model.update(with: storedModel)
        }
    }
    
    func onLoadDocument(_ newDocument: String) {
        let csvModel = InfoEnergyCSVModel(document: newDocument)
        
        if var savedCSVModel = UserManager.shared.saveCVSModel {
            savedCSVModel.update(with: csvModel)
            UserManager.shared.saveCVSModel = savedCSVModel
            self.model.update(with: savedCSVModel)
        } else {
            UserManager.shared.saveCVSModel = csvModel
            
            self.model.update(with: csvModel)
        }
    }
}

#Preview {
    InfoEnergyMainView()
}
