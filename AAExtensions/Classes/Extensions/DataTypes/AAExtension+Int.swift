//
//  AAExtension+Int.swift
//  AAExtensions
//
//  Created by MacBook Pro on 17/03/2019.
//

//MARK:- Int
public extension Int {
    
    var aa_to_mmss : String {
        return "\(((self % 3600) / 60).aa_twoDigit):\(((self % 3600) % 60).aa_twoDigit)"
    }
    
    var aa_twoDigit: String {
        return String(format: "%02d", self)
    }
    
    func aa_toString() -> String {
        return String(self)
    }
}
