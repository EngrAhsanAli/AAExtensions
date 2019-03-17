//
//  AAExtension+Double.swift
//  AAExtensions
//
//  Created by MacBook Pro on 17/03/2019.
//

// MARK:- Double
public extension Double {
    var aa_secondsTommss: String {
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}
