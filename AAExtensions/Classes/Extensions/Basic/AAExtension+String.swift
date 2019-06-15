//
//  AAExtension+String.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
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


// MARK:- String
public extension String {

    var aa_toDateTimeOffset: Date? { return self.trimMillisecond.aa_toDate(fromFormat: "", currentTimeZone: true) }
    
    var aa_url: URL { return URL(string: addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! }
    
    var aa_trimmed: String { return trimmingCharacters(in: .whitespaces) }
    
    var aa_toInt: Int { return Int(self) ?? 0 }
    
    var aa_toFloat: Float { return Float(self) ?? 0 }
    
    var aa_toDouble: Double { return Double(self) ?? 0 }
    
    var aa_encryptBase64: String { return self.data(using: String.Encoding.utf8)!.base64EncodedString(options: .init(rawValue: 0)) }
    
    var aa_decryptDataBase64: Data { return Data(base64Encoded: self, options: .ignoreUnknownCharacters)! }
    
    var aa_decryptBase64: String? { return String(data: aa_decryptDataBase64, encoding: .utf8) }
    
    func aa_left(_ to: Int) -> String { return "\(self[..<self.index(startIndex, offsetBy: to)])" }
    
    func aa_right(_ from: Int) -> String { return "\(self[self.index(startIndex, offsetBy: self.count-from)...])" }
    
    func aa_mid(_ from: Int, amount: Int) -> String { return "\(self[self.index(startIndex, offsetBy: from)...])".aa_left(amount) }
    
    func aa_rangeOfString(find: String) -> Range<String.Index>? { return self.range(of: find, options: .caseInsensitive) }
    
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
    
    fileprivate var trimMillisecond: String {
        if let prefixString = aa_prefix(of: ".") {
            let timeZone: String = String(suffix(6))
            return "\(prefixString)\(timeZone)"
        }
        return self
    }
    
    func aa_toDate(fromFormat: String, currentTimeZone: Bool) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = currentTimeZone ? TimeZone.current : TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: self)
    }
    
    func aa_toDate(fromFormat: AADateFormatters, currentTimeZone: Bool) -> Date? {
        return aa_toDate(fromFormat: fromFormat.rawValue, currentTimeZone: currentTimeZone)
    }
    
    subscript(_ aa_range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, aa_range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, aa_range.upperBound))
        return String(self[idx1..<idx2])
    }
    
    func aa_prefix(of: Character) -> String? {
        if let index = firstIndex(of: of) { return String(prefix(upTo: index)) }
        return nil
    }
    
    func aa_replace(_ originalString: String, with newString: String) -> String {
        return self.replacingOccurrences(of: originalString, with: newString)
    }
    
    func aa_openURL() {
        guard let url = URL(string: self) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func aa_containExtension(_ extensions: [String]) -> Bool {
        if let ext = self.aa_fileExtension {
            return extensions.contains(ext)
        }
        return false
    }
    
    var aa_fileExtension: String? {
        let ext = (self as NSString).pathExtension
        if ext.isEmpty { return nil }
        return ext
    }
    
    var aa_localized: String {
        return NSLocalizedString(self, comment:"")
    }
    
    func aa_localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
    
    func aa_localized(lang:String) -> String {
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    func aa_makePhoneCall() {
        if aa_isValid(regex: .phone) {
            let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
            let onlyDigits = String(String.UnicodeScalarView(filtredUnicodeScalars))
            if let url = URL(string: "tel://\(onlyDigits)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) { UIApplication.shared.open(url) }
                else { UIApplication.shared.openURL(url) }
            }
        }
    }
    
    func aa_capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    var aa_htmlToAttributed: NSAttributedString? {
        guard
            let data = self.data(using: .utf8)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [
                NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    
    var aa_noHtml: String {
        guard let data = self.data(using: .utf8) else { return self }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
    
    func aa_isValid(regex: AARegularExpressions) -> Bool {
        return aa_isValid(regex: regex.rawValue)
    }
    
    func aa_isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
}


//MARK:- String Comparision
public extension String {
    
    static func ==(lhs: String, rhs: String) -> Bool {
        return lhs.compare(rhs, options: .numeric) == .orderedSame
    }
    
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
