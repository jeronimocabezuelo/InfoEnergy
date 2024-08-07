//
//  DateFormatter+Extension.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 7/8/24.
//

import Foundation

extension DateFormatter {
    static var chartAxisX: DateFormatter {
        let result = DateFormatter()
        result.dateFormat = "MMM"
        
        return result
    }
}
