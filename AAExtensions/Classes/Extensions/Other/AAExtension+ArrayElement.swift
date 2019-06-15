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


// MARK: - Array UITextField
public extension Array where Element == UITextField {
    func aa_clear() {
        forEach {
            $0.text = String()
            $0.attributedText = NSAttributedString(string: String())
        }
    }
    
    func aa_enabled(_ isEnabled: Bool) { forEach { $0.isEnabled = isEnabled } }
    
    var aa_validateEmpty: Bool {
        return (filter { $0.text?.isEmpty ?? false }.count > 0)
    }
    
}

// MARK: - Array Equatable
public extension Array where Element: Equatable {
    func aa_indexes(of item: Element) -> [Int]  {
        return enumerated().compactMap { $0.element == item ? $0.offset : nil }
    }
    
}

// MARK: - Array UIView
public extension Array where Element == UIView {
    func aa_setVisibility(isHidden: Bool) { forEach { $0.isHidden = isHidden } }
}

// MARK: - Array AAReversibleConstraint
public extension Array where Element == AAReversibleConstraint {
    func setVisibility(_ isHidden: Bool) { forEach { $0.showHide(isHidden) } }
    
}

// MARK: - RangeReplaceableCollection
public extension RangeReplaceableCollection where Element: Equatable {
    
    mutating func aa_appendOrRemove(_ element: Element) {
        if let index = firstIndex(of: element) {
            remove(at: index)
        }
        else {
            insert(element, at: endIndex)
        }
    }
    
    mutating func aa_appendUnique(_ element: Element) {
        if firstIndex(of: element) == nil {
            insert(element, at: endIndex)
        }
    }
    
    mutating func aa_remove(_ element: Element) {
        guard let index = firstIndex(of: element) else { return }
        remove(at: index)
    }
}
