//
//  Calendar+Extension.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 30/7/24.
//

import Foundation

extension Calendar {
    enum NationalHoliday {
        case newYear
        case epiphany
        case goodFriday
        case labourDay
        case assumptionOfMary
        case nationalDay
        case allSaintsDay
        case constitutionDay
        case immaculateConception
        case christmasDay
        
        var name: String {
            switch self {
            case .newYear: return "Año Nuevo"
            case .epiphany: return "Día de Reyes"
            case .goodFriday: return "Viernes Santo"
            case .labourDay: return "Día del Trabajador"
            case .assumptionOfMary: return "Asunción de la Virgen"
            case .nationalDay: return "Día de la Hispanidad"
            case .allSaintsDay: return "Día de Todos los Santos"
            case .constitutionDay: return "Día de la Constitución"
            case .immaculateConception: return "Inmaculada Concepción"
            case .christmasDay: return "Navidad"
            }
        }
    }
    
    func isDateInNationalHoliday(_ date: Date) -> Bool {
        let year = component(.year, from: date)
        let holidays = Calendar.nationalHolidays(for: year)
        return holidays.contains { isDate($0.date, inSameDayAs: date) }
    }
    
    static func nationalHolidays(for year: Int) -> [(date: Date, holiday: NationalHoliday)] {
        var holidays: [(Date, NationalHoliday)] = []
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let holidayDates: [(String, NationalHoliday)] = [
            ("\(year)-01-01", .newYear),
            ("\(year)-01-06", .epiphany),
            // El Viernes Santo varía cada año, se debe calcular
            ("\(year)-05-01", .labourDay),
            ("\(year)-08-15", .assumptionOfMary),
            ("\(year)-10-12", .nationalDay),
            ("\(year)-11-01", .allSaintsDay),
            ("\(year)-12-06", .constitutionDay),
            ("\(year)-12-08", .immaculateConception),
            ("\(year)-12-25", .christmasDay)
        ]
        
        for (dateString, holiday) in holidayDates {
            if let date = dateFormatter.date(from: dateString),
               let adjustedDate = calendar.adjustForSunday(date) {
                
                holidays.append((adjustedDate, holiday))
            }
        }
        
        // Calcular el Viernes Santo
        if let goodFriday = calculateGoodFriday(for: year) {
            holidays.append((goodFriday, .goodFriday))
        }
        
        return holidays
    }
    
    func adjustForSunday(_ date: Date) -> Date? {
        let weekday = component(.weekday, from: date)
        
        if weekday == 1 { // 1 representa el domingo en Calendar
            return self.date(byAdding: .day, value: 1, to: date)
        }
        
        return date
    }
    
    static func calculateGoodFriday(for year: Int) -> Date? {
        // Algoritmo de cálculo de la fecha de Pascua (domingo de Pascua)
        let a = year % 19
        let b = year / 100
        let c = year % 100
        let d = b / 4
        let e = b % 4
        let f = (b + 8) / 25
        let g = (b - f + 1) / 3
        let h = (19 * a + b - d - g + 15) % 30
        let i = c / 4
        let k = c % 4
        let l = (32 + 2 * e + 2 * i - h - k) % 7
        let m = (a + 11 * h + 22 * l) / 451
        let month = (h + l - 7 * m + 114) / 31
        let day = ((h + l - 7 * m + 114) % 31) + 1
        
        let easterSundayComponents = DateComponents(year: year, month: month, day: day)
        let calendar = Calendar.current
        if let easterSunday = calendar.date(from: easterSundayComponents) {
            return calendar.date(byAdding: .day, value: -2, to: easterSunday) // Viernes Santo es dos días antes del domingo de Pascua
        }
        return nil
    }
    
    func daysBetween(from dateFirst: Date, to dateSecond: Date) -> Int {
        let components = dateComponents([.day], from: dateFirst, to: dateSecond)
        return components.day ?? 0
    }
    
}
