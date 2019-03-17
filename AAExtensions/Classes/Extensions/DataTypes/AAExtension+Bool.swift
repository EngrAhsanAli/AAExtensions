//
//  AAExtension+Bool.swift
//  AAExtensions
//
//  Created by MacBook Pro on 17/03/2019.
//

// MARK:- Bool
public extension Bool {
    
    mutating func aa_toggle() {
        if self {
            self = false
            return
        }
        self = true
    }
    
}
