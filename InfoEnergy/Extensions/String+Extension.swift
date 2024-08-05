//
//  String+Extension.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 29/7/24.
//

import Foundation

extension String {
    enum CustomDateFormat: String {
        case presentationDateFormat = "dd/MM/yyyy"
    }
    
    func createDate(dateFormat: CustomDateFormat = .presentationDateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        
        return dateFormatter.date(from: self)
    }
}
