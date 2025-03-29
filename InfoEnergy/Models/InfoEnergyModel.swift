//
//  InfoEnergyModel.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 6/8/24.
//

import SwiftUI
import DeveloperKit

class InfoEnergyModel: ObservableObject {
    @Published var startDate: Date = InfoEnergyCSVModel.mock.items.first?.date ?? .now
    @Published var endDate: Date = InfoEnergyCSVModel.mock.items.last?.date ?? .now
    @Published var range: Int = 7
    @Published private(set) var rawDataModel: InfoEnergyCSVModel = .mock
    @Published var hoveredPeriod: Period?
    
    @Published var showLines: Bool = true
    @Published var showBars: Bool = true
    @Published var showInvoces: Bool = false
    
    func update(with model: InfoEnergyCSVModel?) {
        let model = model ?? .mock
        
        rawDataModel = model
        startDate = model.items.first?.date ?? .now
        endDate = model.items.last?.date ?? .now
    }
}
