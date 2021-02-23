//
//  ServiceProtocol.swift
//  DeltaKit
//
//  Created by Vasco d'Orey on 22/02/2021.
//

import Foundation

/// Base protocol app services must inherit from
public protocol ServiceProtocol: class {
    
    static var logLevel: LogLevel { get }
    
    func log(_ level: LogLevel, _ str: StaticString, _ args: CVarArg ...)
    
}


public extension ServiceProtocol {
    
    static var logLevel: LogLevel {
        return .info
    }
    
    func log(_ level: LogLevel, _ str: StaticString, _ args: CVarArg ...) {
        guard Self.logLevel.validate(level) else { return }
        
        Logger.shared.log(level, str, args)
    }
    
}
