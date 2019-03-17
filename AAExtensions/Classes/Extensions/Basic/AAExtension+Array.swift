//
//  AAExtension+Array.swift
//  AAExtensions
//
//  Created by MacBook Pro on 16/03/2019.
//

// MARK:- Array
public extension Array{
    mutating func aa_prepend(_ newItem : Element){
        let copy = self
        self = []
        self.append(newItem)
        self.append(contentsOf: copy)
    }
}
