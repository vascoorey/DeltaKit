//
//  Logging.swift
//  DeltaKit
//
//  Created by Vasco d'Orey on 22/02/2021.
//

import Foundation
import os.log

public enum LogLevel: Int {
    
    case none = 0
    case info = 1
    case debug = 2
    case warning = 3
    case error = 4
    
    internal var osLogType: OSLogType {
        switch self {
        case .info:
            return .info
        case .debug:
            return .debug
        case .warning:
            return .fault
        case .error:
            return .error
        default:
            return .default
        }
    }
    
    internal func validate(_ other: LogLevel) -> Bool {
        // If the log level is none, then log nothing (i.e. don't validate), otherwise:
        // Only validate if the other log level is contained in the current one.
        
        guard self != .none && other != .none else { return false }
        
        return other.rawValue >= self.rawValue
    }
    
}

public protocol LoggingService {
    
    func log(_ level: LogLevel, _ str: StaticString, _ args: CVarArg ...)
    
}

public final class Logger: LoggingService {
    
    /* Logger Singleton Accessor */
    static let shared = Logger()
    
    internal init() {}
    
    public func log(_ level: LogLevel, _ str: StaticString, _ args: CVarArg ...) {
        os_log(level.osLogType, str, args)
    }
    
}
