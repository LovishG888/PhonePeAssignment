//
//  CacheHelper.swift
//  PhonePeProject
//
//  Created by LOVISH on 25/11/23.
//

import Foundation


extension UserDefaults {
    func setCodableObject<T: Codable>(_ data: [T]?, forKey defaultName: String) {
        let encoded = try? JSONEncoder().encode(data)
        set(encoded, forKey: defaultName)
    }
    
    func getCodableObject<T : Codable>(dataType: T.Type, key: String) -> [T]? {
        guard let userDefaultData = data(forKey: key) else {
            return nil
        }
        return try? JSONDecoder().decode([T].self, from: userDefaultData)
    }
}

