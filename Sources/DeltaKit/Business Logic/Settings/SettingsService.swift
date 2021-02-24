//
//  SettingsService.swift
//  DeltaKit
//
//  Created by Vasco d'Orey on 24/02/2021.
//

import Foundation

enum PrivacyLevel {
    
    case standard
    
    case sensitive
    
}

protocol SettingsServiceProtocol: ServiceProtocol {
    
    func value<T: Encodable>(forKey: String) -> T?
    
    func set<T: Encodable>(value: T, for key: String, with level: PrivacyLevel)
    
    func allKeys() -> [String]
    
    func clearAllData()
    
}

extension SettingsServiceProtocol {
    
    func set<T: Encodable>(value: T, for key: String) {
        set(value: value, for: key, with: .standard)
    }
    
}
