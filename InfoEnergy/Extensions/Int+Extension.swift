//
//  Int+Extension.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 30/7/24.
//

import Foundation

extension Int {
    
    var period: Period {
        if [0, 1, 2, 3, 4, 5, 6, 7].contains(where: { $0 == self }) {
            return .valley
        } else if [8, 9, 14, 15, 16, 17, 22, 23].contains(where: { $0 == self }) {
            return .flat
        } else {
            return .point
        }
    }
}
