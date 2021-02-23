//
//  FileService.swift
//  DeltaKit
//
//  Created by Vasco d'Orey on 18/01/2021.
//

import Foundation

protocol FileServiceProtocol: ServiceProtocol {
    
    var applicationSupportDirectory: URL { get }
    
}

final class FileService: FileServiceProtocol {
    
    var applicationSupportDirectory: URL
    
    init() {
        let result: URL
        
        do {
            let fileManager = FileManager.default
            
            result = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        }
        catch {
            preconditionFailure(error.localizedDescription)
        }
        
        applicationSupportDirectory = result
    }
    
    
}
