//
//  Array+Extension.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 29/7/24.
//

import Foundation

extension Array {
    func at(_ index: Int?) -> Element? {
        guard let index = index
        else { return nil }
        
        return at(index)
    }
    
    func at(_ index: Int) -> Element? {
        guard index >= 0,
              index < count
        else { return nil }
        
        return self[index]
    }
    
    func at(_ range: Range<Int>) -> [Element] {
        return range.compactMap({ at($0) })
    }
    
    func grouped<Key: Hashable>(by keyForValue: (Element) -> Key) -> [(Key, Self)] {
        Dictionary(
            grouping: self,
            by: keyForValue
        )
        .map({ ($0.key, $0.value)})
    }
}

extension Array where Element: Collection {
    func flatten() -> [Element.Element] {
        return self.flatMap { $0 }
    }
}
