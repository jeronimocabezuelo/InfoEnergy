//
//  PEriod.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 29/7/24.
//

import Foundation
import SwiftUI

enum Period: Int, CaseIterable {
    /// Valle
    case valley
    /// Llano
    case flat
    /// Punta
    case point
    /// Total
    case total
    
    var color: Color {
        switch self {
        case .valley: return .blue
        case .flat: return .green
        case .point: return .gray
        case .total: return .orange
        }
    }
}

extension Period: Comparable {
    static func < (lhs: Period, rhs: Period) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
