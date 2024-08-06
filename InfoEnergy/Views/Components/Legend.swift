//
//  Legend.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 5/8/24.
//

import SwiftUI

struct Legend: View {
    var body: some View {
        HStack {
            DividedForEach(Period.allCases, id: \.self) { period in
                HStack {
                    Rectangle()
                        .fill(period.color)
                        .frame(width: 24, height: 24)
                        .clipShape(.rect(cornerRadius: 4))
                    Text(period.title)
                }
            } divider: {
                Spacer()
            }
        }
    }
}
