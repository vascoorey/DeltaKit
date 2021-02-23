//
//  WeakContainer.swift
//  DeltaKit
//
//  Created by Vasco d'Orey on 23/02/2021.
//

import Foundation


final class WeakContainer {
    
    weak var storage: AnyObject?
    
    func unwrapped<T: AnyObject>() -> T? {
        return storage as? T
    }
    
}
