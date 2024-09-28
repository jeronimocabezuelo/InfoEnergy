//
//  UserManager.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 27/9/24.
//

import Foundation

enum UserDefaultKey: String {
    case saveCVSModel
}

@propertyWrapper struct UserDefault<T> {
    let key: UserDefaultKey
    let defaultValue: T? = nil
    let storage = UserDefaults.standard
    
    var wrappedValue: T? {
        get { storage.value(forKey: key.rawValue) as? T }
        set { storage.setValue(newValue, forKey: key.rawValue) }
    }
}

@propertyWrapper struct UserDefaultData<T: Codable> {
    let key: UserDefaultKey
    let defaultValue: T? = nil
    let storage = UserDefaults.standard
    
    var wrappedData: Data? {
        get { storage.value(forKey: key.rawValue) as? Data }
        set { storage.setValue(newValue, forKey: key.rawValue) }
    }
    
    var wrappedValue: T? {
        get {
            guard let data = wrappedData else { return nil }
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                print("Error decoding \(T.self): \(error)")
                return nil
            }
        }
        set {
            if let newValue {
                do {
                    wrappedData = try JSONEncoder().encode(newValue)
                } catch {
                    print("Error encoding InfoEnergyCSVModel: \(error)")
                    wrappedData = nil
                }
            } else {
                wrappedData = nil
            }
        }
    }
}

class UserManager {
    static var shared = UserManager()
    
    private init() {}
        
    @UserDefaultData(key: .saveCVSModel)
    var saveCVSModel: InfoEnergyCSVModel?
}
