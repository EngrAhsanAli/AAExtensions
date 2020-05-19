//
//  AAExtensions+Mirror.swift
//  AAExtensions
//
//  Created by Muhammad Ahsan Ali on 2020/05/20.
//

import Foundation

public extension Mirror {
    
    static func aa_filterText(_ text: String, data: Any?, index: Int = 0) -> [Int]?  {
        var indexes = [Int]()
        
        if let string = data as? String, string.lowercased().contains(text.lowercased()) {
            indexes.append(index)
        }
        else if let mirror = data as? Mirror {
            mirror.children.forEach {
                if let result = aa_filterText(text, data: $0.value, index: index + 1) {
                    indexes.append(contentsOf: result)
                }
            }
        }
        else {
            if let data = data {
                let child = Mirror(reflecting: data)
                return aa_filterText(text, data: child, index: index)
            }
        }
        
        return (indexes.count > 0 ? indexes : nil)
    }
}
