//
//  LocalizationService.swift
//  DeltaKit
//
//  Created by Vasco d'Orey on 23/02/2021.
//

import Foundation


public enum LocalizationStoreOptions {
    
    ///
    /// Store the localization in the settings service under the provided name
    case settings(String)
    /// Store the localization directly in the application support directory
    case applicationSupport(String)
    /// Client provides a custom store via a closure. Certain things might not work as desired (change notifications won't be fired)
    case custom((String) -> String)
    
}


public protocol LocalizationServiceProtocol {
    
    var storeOptions: LocalizationStoreOptions { get }
    
    init(options: LocalizationStoreOptions)
    
    func set(localizationStore: [String: String])
    
    func localizedString(for key: String) -> String
    
    func observeChanges(to key: String, with handler: (String) -> ())
    
}


public final class LocalizationService: LocalizationServiceProtocol {
    
    let fileService: FileServiceProtocol = registeredService()
    
    private var currentLocalization: [String: String] = [:]
    
    private var observers = [String: [WeakContainer]]()
    
    public let storeOptions: LocalizationStoreOptions
    
    public init(options: LocalizationStoreOptions) {
        storeOptions = options
    }
    
    
    public func set(localizationStore: [String : String]) {
        
    }
    
    
    public func localizedString(for key: String) -> String {
        return ""
    }
    
    
    public func observeChanges(to key: String, with handler: (String) -> ()) {
        
    }
    
    
}

