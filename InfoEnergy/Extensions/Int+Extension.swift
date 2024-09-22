//
//  Int+Extension.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 30/7/24.
//

import Foundation

extension Int {
    
    static var valleyHours: [Int] {
        [0, 1, 2, 3, 4, 5, 6, 7]
    }
    
    static var flatHours: [Int] {
        [8, 9, 14, 15, 16, 17, 22, 23]
    }
    
    static var pointHours: [Int] {
        [10, 11, 12, 13, 18, 19, 20, 21]
    }
    
    var period: Period {
        if Self.valleyHours.contains(where: { $0 == self }) {
            return .valley
        } else if Self.flatHours.contains(where: { $0 == self }) {
            return .flat
        } else {
            return .point
        }
    }
    
    func isBetween(_ min: Int, max: Int) -> Bool {
        return min <= self && self <= max
    }
}
