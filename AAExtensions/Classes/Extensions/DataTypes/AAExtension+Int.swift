//
//  AAExtension+Int.swift
//  AAExtensions
//
//  Created by MacBook Pro on 17/03/2019.
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


//MARK:- Int
public extension Int {
    
    var aa_to_mmss : String { "\(((self % 3600) / 60).aa_twoDigit):\(((self % 3600) % 60).aa_twoDigit)" }
    
    var aa_twoDigit: String { String(format: "%02d", self) }
    
    var aa_toString: String { String(self) }
    
    var aa_boolValue: Bool { self != 0 }
        
    func aa_toLocalizedString(locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale // Locale(identifier: "ar")
        return formatter.string(from: NSNumber(integerLiteral: self)) ?? aa_toString
    }

}

