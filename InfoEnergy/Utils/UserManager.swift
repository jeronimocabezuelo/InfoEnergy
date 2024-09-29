//
//  UserManager.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 27/9/24.
//

import Foundation
import DeveloperKit

public enum UserDefaultKey: String {
    case saveCVSModel
}

class UserManager {
    static var shared = UserManager()
    
    private init() {}
        
    @UserDefaultData(key: UserDefaultKey.saveCVSModel)
    var saveCVSModel: InfoEnergyCSVModel?
}
