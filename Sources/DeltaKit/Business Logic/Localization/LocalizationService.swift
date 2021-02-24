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
    
}


public protocol LocalizationServiceProtocol: ServiceProtocol {
    
    var storeOptions: LocalizationStoreOptions { get }
    
    init(options: LocalizationStoreOptions)
    
    func set(localizationStore: [String: String])
    
    func localizedString(for key: String) -> String
    
    func observeChanges(to key: String, with handler: (String) -> ())
    
}


public final class LocalizationService: LocalizationServiceProtocol {
    
    private let fileService: FileServiceProtocol = registeredService()
    
    private let settingsService: SettingsServiceProtocol = registeredService()
    
    private var currentLocalization: [String: String] = [:]
    
    private var observers = [String: (String?, [WeakContainer])]()
    
    public let storeOptions: LocalizationStoreOptions
    
    public init(options: LocalizationStoreOptions) {
        storeOptions = options
        
        switch options {
        case .applicationSupport(let path):
            // Try to load the saved localization from the provided path
            let localizationPath = fileService.applicationSupportDirectory.appendingPathComponent(path)
            
            do {
                if FileManager.default.fileExists(atPath: localizationPath.absoluteString),
                   let localizationData = FileManager.default.contents(atPath: localizationPath.absoluteString),
                   let localization = try JSONSerialization.jsonObject(with: localizationData, options: .allowFragments) as? [String: String] {
                    currentLocalization = localization
                }
            }
            catch {
                // There was an error reading the localization file, if one exists we should delete it.
                log(.error, "Error reading localization file: %@", error.localizedDescription)
                if FileManager.default.fileExists(atPath: localizationPath.absoluteString) {
                    log(.error, "File will be deleted")
                    do {
                        try FileManager.default.removeItem(at: localizationPath)
                    } catch {
                        fatalError("Expected to be able to delete an existing file. App will be in an inconsistent state with a bad localization. Bailing out (for now): \(error.localizedDescription)")
                    }
                }
                
            }
        case .settings(let key):
            // Try loading from the settings service
            if let localization: [String: String] = settingsService.value(forKey: key) {
                currentLocalization = localization
            }
        }
    }
    
    
    public func set(localizationStore: [String : String]) {
        
    }
    
    
    public func localizedString(for key: String) -> String {
        return ""
    }
    
    
    public func observeChanges(to key: String, with handler: (String) -> ()) {
        
    }
    
    
}

