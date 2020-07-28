//
//  AAExtensions+Mirror.swift
//  AAExtensions
//
//  Created by Muhammad Ahsan Ali on 2020/05/20.
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
