//
//  ServiceLocator.swift
//  DeltaKit
//
//  Created by Vasco d'Orey on 18/01/2021.
//

import Foundation


public func registeredService<T>() -> T {
    return ServiceLocator.validated()
}


public protocol ServiceLocatorProtocol {
    
    /// You should register ServiceProtocol types, type conformity is checked at runtime
    /// (There is no compile time validation in order to be able to fetch implementations as their protocol types).
    func register<T>(service: T)
    
    /// You should fetch ServiceProtocol types, type conformity is checked at runtime
    /// (There is no compile time validation in order to be able to fetch implementations as their protocol types).
    func fetch<T>() -> T?
    
    /// You should fetch ServiceProtocol types, type conformity is checked at runtime
    /// (There is no compile time validation in order to be able to fetch implementations as their protocol types).
    func with<T>(execute: @escaping (T) -> ())
    
    /// Clears the backing store.
    func clearAllServices()
    
}


public final class ServiceLocator: ServiceLocatorProtocol {

    
    /// Services queue, might be over-engineered but organizes access to the service storage.
    /// Fetching is async (albeit with a barrier, to allow for blocks to finish off before firing)
    /// Registering is sync.
    private lazy var serviceQueue = DispatchQueue(label: "ServiceLocatorQueue")
    
    /// Services storage, accessing a service of a specialized type will require to be casted.
    private lazy var services = [String : Any]()
    
    /// Storage for pending closures that depend on some service.
    private lazy var waitingQueue = [String : [Any]]()

    
    ///
    /// Singleton Accessor
    ///
    
    
    static let shared: ServiceLocator = ServiceLocator()
    
    
    internal static func validated<T>() -> T {
        return shared.fetch().validated
    }
    
    
    ///
    /// Initialization
    ///
    
    
    private init() { /* Prevent other creations aside from singleton accessor */ }
    
    
    ///
    /// ServiceLocatorProtocol Implementation
    ///
    
    private func validateType<T>(_ imp: T) {
        if !(imp is ServiceProtocol) {
            fatalError("Invalid type not conforming to ServiceProtocol: \(T.self)")
        }
    }
    
    
    /// Register service to the services backing storage
    public func register<T>(service: T) {
        validateType(service)
        
        serviceQueue.async(flags: .barrier) {
            self.services["\(T.self)"] = service
            
            if let queue = self.waitingQueue["\(T.self)"] {
                queue.forEach { validate($0 as? (T) -> ())(service) }
                
                self.waitingQueue["\(T.self)"] = nil
            }
        }
    }
    
    /// Fetch a service from the backing storage
    public func fetch<T>() -> T? {
        var implementation: T?
        
        serviceQueue.sync {
            implementation = self.services["\(T.self)"] as? T
        }
        
        return implementation
    }
    
    public func with<T>(execute: @escaping (T) -> ()) {
        if let imp: T = self.fetch() {
            execute(imp)
        } else {
            serviceQueue.async(flags: .barrier) {
                var queue = self.waitingQueue["\(T.self)"] ?? [Any]()
                
                queue.append(execute)
                
                self.waitingQueue["\(T.self)"] = queue
            }
        }
    }
    
    public func clearAllServices() {
        serviceQueue.sync {
            self.waitingQueue = [String: [Any]]()
            self.services = [String: Any]()
        }
    }
    
}
