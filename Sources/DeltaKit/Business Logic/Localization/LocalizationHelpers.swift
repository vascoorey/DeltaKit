//
//  LocalizationHelpers.swift
//  DeltaKit
//
//  Created by Vasco d'Orey on 23/02/2021.
//

import Foundation

extension String {
    
    var localized: String? {
        let localizationService: LocalizationServiceProtocol = registeredService()
        
        return localizationService.localizedString(for: self)
    }
    
}
