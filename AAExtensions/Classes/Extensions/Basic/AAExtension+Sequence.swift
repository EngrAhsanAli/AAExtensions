//
//  AAExtension+Sequence.swift
//  AAExtensions
//
//  Created by MacBook Pro on 17/03/2019.
//

// MARK:- Sequence
public extension Sequence {
    func aa_group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        return Dictionary.init(grouping: self, by: key)
    }
}
