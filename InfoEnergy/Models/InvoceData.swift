//
//  InvoceData.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 31/1/25.
//

import Foundation
import DeveloperKit

typealias TupleVFP = (valley: CGFloat, flat: CGFloat, point: CGFloat)

struct InvoceData: Codable, Identifiable {
    var id: UUID = UUID()
    let energy: [InvoceItemData]
    let energyGeneration: [InvoceItemData]
    
    var energyTotal: CGFloat { energy.map({ $0.total }).sum()}
    var energyGenerationTotal: CGFloat { energyGeneration.map({ $0.total }).sum()}
    
    var use: CGFloat { energy.use + energyGeneration.use }
    
    var total: CGFloat { energyTotal + energyGenerationTotal }
    
    var start: Date? {
        [energy.start, energyGeneration.start].compact().min()
    }
    
    var end: Date? {
        [energy.end, energyGeneration.end].compact().max()
    }
    
    var period: DateRange? {
        return DateRange(start: start, end: end)
    }
}

extension Array where Element == InvoceItemData {
    var start: Date? { self.map({ $0.period.start }).min() }
    var end: Date? { self.map({ $0.period.end }).max() }
    var valleyUse: CGFloat { self.map({ $0.valleyUse }).sum() }
    var flatUse: CGFloat { self.map({ $0.flatUse }).sum() }
    var pointUse: CGFloat { self.map({ $0.pointUse }).sum() }
    var use: CGFloat { valleyUse + flatUse + pointUse }
    var valleyPrice: CGFloat { self.map({ $0.valleyPrice }).sum() }
    var flatPrice: CGFloat { self.map({ $0.flatPrice }).sum() }
    var pointPrice: CGFloat { self.map({ $0.pointPrice }).sum() }
}

struct InvoceItemData: Codable, Identifiable {
    var id: UUID = UUID()
    
    let period: DateRange
    
    let valleyUse: CGFloat
    let flatUse: CGFloat
    let pointUse: CGFloat
    
    let valleyPrice: CGFloat
    let flatPrice: CGFloat
    let pointPrice: CGFloat
    
    var valleyTotal: CGFloat { valleyUse * valleyPrice }
    var flatTotal: CGFloat { flatUse * flatPrice }
    var pointTotal: CGFloat { pointUse * pointPrice }
    var total: CGFloat { valleyTotal + flatTotal + pointTotal }
}

extension InvoceItemData {
    init(period: DateRange, uses: TupleVFP, prices: TupleVFP) {
        self.init(
            period: period,
            valleyUse: uses.valley,
            flatUse: uses.flat,
            pointUse: uses.point,
            valleyPrice: prices.valley,
            flatPrice: prices.flat,
            pointPrice: prices.point
        )
    }
}

extension Array where Element == InvoceItemData {
    init(periods: [DateRange], uses: [TupleVFP], prices: [TupleVFP]) {
        self = zip(periods, zip(uses, prices)).map { (period: $0.0, uses: $0.1.0, prices: $0.1.1) }
            .map({
                InvoceItemData(
                    period: $0.period,
                    uses: $0.uses,
                    prices: $0.prices
                )
            })
    }
}
