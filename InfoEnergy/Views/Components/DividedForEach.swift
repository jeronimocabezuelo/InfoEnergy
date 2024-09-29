//
//  DividedForEach.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 5/8/24.
//

import SwiftUI

struct DividedForEach<Data: RandomAccessCollection, ID: Hashable, Content: View, D: View>: View {
    let data: Data
    let id: KeyPath<Data.Element, ID>
    let content: (Data.Element) -> Content
    let divider: (() -> D)
    
    init(_ data: Data, id: KeyPath<Data.Element, ID>, content: @escaping (Data.Element) -> Content, divider: @escaping () -> D) {
        self.data = data
        self.id = id
        self.content = content
        self.divider = divider
    }
    
    var body: some View {
        ForEach(data, id: id) { element in
            content(element)
            
            if element[keyPath: id] != data.last?[keyPath: id] {
                divider()
            }
        }
    }
}
