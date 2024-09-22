//
//  HoverView.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 22/9/24.
//

import SwiftUI

struct HoveredView<Content: View, HoverView: View>: View {
    @ViewBuilder var content: () -> Content
    @ViewBuilder var hoverView: () -> HoverView
    
    @State private var hover: Bool = false
    
    var body: some View {
        ZStack {
            content()
                .onHover { hover in
                    self.hover = hover
                }
            if hover {
                hoverView()
                    .onHover { hover in
                        self.hover = hover
                    }
            }
        }
    }
}

struct HoverView<Content: View>: View {
    @Binding var hover: Bool
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ZStack {
            content()
                .onHover { hover in
                    self.hover = hover
                }
        }
    }
}
