//
//  Color+Extension.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 21/9/24.
//

import SwiftUI

extension Color {
    static var annotationBackground: Color {
#if os(macOS)
        return Color(nsColor: .controlBackgroundColor)
#else
        return Color(uiColor: .secondarySystemBackground)
#endif
    }
    
    static let pourColor: Color = .red
}
