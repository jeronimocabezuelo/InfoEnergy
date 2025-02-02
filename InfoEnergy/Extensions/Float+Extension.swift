//
//  Float+Extension.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 21/9/24.
//

import Foundation

extension CGFloat {
    init?(truncating: NSNumber?) {
        guard let truncating else { return nil }
        self.init(truncating: truncating)
    }
}

extension Float {

}
