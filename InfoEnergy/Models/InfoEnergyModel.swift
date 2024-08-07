//
//  InfoEnergyModel.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 6/8/24.
//

import SwiftUI

class InfoEnergyModel: ObservableObject {
    @Published var startDate: Date = InfoEnergyCSVModel.mock.items.first?.date ?? .now
    @Published var endDate: Date = InfoEnergyCSVModel.mock.items.last?.date ?? .now
    @Published var range: Int = 7
    @Published var rawDataModel: InfoEnergyCSVModel = .mock
}
