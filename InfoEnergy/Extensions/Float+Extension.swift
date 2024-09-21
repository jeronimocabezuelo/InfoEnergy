//
//  Float+Extension.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 21/9/24.
//

import Foundation

extension Float {
    func toDecimalString(maxDecimals: Int = 2, minDecimals: Int = 0) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = minDecimals
        formatter.maximumFractionDigits = maxDecimals
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
