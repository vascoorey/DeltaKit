//
//  Helpers.swift
//  DeltaKit
//
//  Created by Vasco d'Orey on 18/01/2021.
//

import Foundation
import UIKit
import Promises

public extension Promise where Value == Void {
    
    func _fulfill() {
        return fulfill(())
    }
    
}


///
/// Validates an assumption that the value of `constructor` is not `nil`
///
/// In the event that it is `nil` the program will crash with the provided `message` as this is to be treated as an implementation error.
///
public func validate<T>(_ constructor: @autoclosure () -> T?, message: String = "Fatal error: got nil instead of a \(T.self)") -> T {
    let result = constructor()
    
    precondition(result != nil, message)
    
    return result!
}

public extension Optional {
    
    var validated: Wrapped {
        return validate(self)
    }
    
}

public extension NSLayoutConstraint {
    
    func activated() {
        isActive = true
    }
    
}

