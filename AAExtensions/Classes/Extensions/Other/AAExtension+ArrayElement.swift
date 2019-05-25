//
//  AAExtension+ArrayElement.swift
//  AAExtensions
//
//  Created by Ahsan ALI on 25/05/2019.
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


public extension Array where Element == UITextField {
    func aa_clear() { forEach { $0.text = String() } }
    
    func aa_enabled(_ isEnabled: Bool) { forEach { $0.isEnabled = isEnabled } }
    
    var aa_validateEmpty: Bool {
        return (filter { $0.text?.isEmpty ?? false }.count > 0)
    }
    
}

public extension Array where Element: Equatable {
    
    func aa_indexes(of item: Element) -> [Int]  {
        return enumerated().compactMap { $0.element == item ? $0.offset : nil }
    }
    
}

public extension Array where Element == UIView {
    
    func aa_setVisibility(isHidden: Bool) { forEach { $0.isHidden = isHidden } }
}

public extension Array where Element == AAReversibleConstraint {
    
    func setVisibility(_ isHidden: Bool) { forEach { $0.showHide(isHidden) } }
    
}
