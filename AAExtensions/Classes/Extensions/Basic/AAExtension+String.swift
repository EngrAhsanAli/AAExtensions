//
//  AAExtension+String.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

// MARK:- String
public extension String {
    
    fileprivate var trimMillisecond: String {
        var beforeDot: String = ""
        if let indexDot = aa_indexInt(of: ".") {
            beforeDot = self.aa_left(indexDot)
            let timeZone: String = String(suffix(6))
            return "\(beforeDot)\(timeZone)"
        }
        return self
    }
    
    func aa_toDate(fromFormat: String, currentTimeZone: Bool) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = currentTimeZone ? TimeZone.current : TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: self)!
    }

    var aa_toDateTimeOffset: Date {
        let dataTime = self.trimMillisecond
        return dataTime.aa_toDate(fromFormat: "", currentTimeZone: true)
    }
    
    var aa_trimmed: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    func aa_toInt() -> Int {
        return Int(self) ?? 0
    }
    
    func aa_toFloat() -> Float {
        return Float(self) ?? 0
    }
    
    var aa_initialLetters: String {
        let components = self.components(separatedBy: " ")
        var string: String = ""
        if let first = components[aa_optional: 0]?.first {
            string.append(first)
        }
        if let last = components[aa_optional: 1]?.first {
            string.append(last)
        }
        return string.uppercased()
    }
    
    func aa_replace(_ originalString:String, with newString:String) -> String {
        return self.replacingOccurrences(of: originalString, with: newString)
    }
    
    var aa_encryptBase64: String {
        let data = self.data(using: String.Encoding.utf8)
        return data!.base64EncodedString(options: .init(rawValue: 0))
    }
    
    var aa_decryptDataBase64: Data {
        return Data(base64Encoded: self, options: .ignoreUnknownCharacters)!
    }
    
    var aa_decryptBase64: String? {
        let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters)
        if let base64Data = data {
            return String(data: base64Data, encoding: .utf8)
        }
        return nil
    }
    
    func aa_indexInt(of char: Character) -> Int? {
        return index(of: char)?.encodedOffset
    }
    
    func aa_left(_ to: Int) -> String {
        return "\(self[..<self.index(startIndex, offsetBy: to)])"
    }
    
    func aa_right(_ from: Int) -> String {
        return "\(self[self.index(startIndex, offsetBy: self.count-from)...])"
    }
    
    func aa_mid(_ from: Int, amount: Int) -> String {
        let x = "\(self[self.index(startIndex, offsetBy: from)...])"
        return x.aa_left(amount)
    }
    
    func aa_rangeOfString(find: String) -> Range<String.Index>? {
        return self.range(of: find, options: .caseInsensitive)
    }
    
    subscript(_ aa_range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, aa_range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, aa_range.upperBound))
        return String(self[idx1..<idx2])
    }
    
}

//MARK:- String Comparision
public extension String {

//    static func ==(lhs: String, rhs: String) -> Bool {
//        return lhs.compare(rhs, options: .numeric) == .orderedSame
//    }
    
    static func <(lhs: String, rhs: String) -> Bool {
        return lhs.compare(rhs, options: .numeric) == .orderedAscending
    }
    
    static func <=(lhs: String, rhs: String) -> Bool {
        return lhs.compare(rhs, options: .numeric) == .orderedAscending || lhs.compare(rhs, options: .numeric) == .orderedSame
    }
    
    static func >(lhs: String, rhs: String) -> Bool {
        return lhs.compare(rhs, options: .numeric) == .orderedDescending
    }
    
    static func >=(lhs: String, rhs: String) -> Bool {
        return lhs.compare(rhs, options: .numeric) == .orderedDescending || lhs.compare(rhs, options: .numeric) == .orderedSame
    }
}
