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

import NaturalLanguage

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
        aa_toDate(fromFormat: fromFormat.rawValue, currentTimeZone: currentTimeZone)
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
        self.replacingOccurrences(of: originalString, with: newString)
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
        aa_isValid(regex: regex.rawValue)
    }
    
    func aa_isValid(regex: String) -> Bool {
        (range(of: regex, options: .regularExpression)) != nil
    }
    
    subscript (aa_range: CountableClosedRange<Int>) -> String {
        let startIndex =  self.index(self.startIndex, offsetBy: aa_range.lowerBound)
        let endIndex = self.index(startIndex, offsetBy: aa_range.upperBound - aa_range.lowerBound)
        return String(self[startIndex...endIndex])
    }
    
    func aa_width(usingFont font: UIFont) -> CGFloat {
        self.size(withAttributes: [NSAttributedString.Key.font: font]).width
    }
    
    func aa_height(usingFont font: UIFont) -> CGFloat {
        self.size(withAttributes: [NSAttributedString.Key.font: font]).height
    }
    
    func aa_size(usingFont font: UIFont) -> CGSize {
        self.size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
    func aa_height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    var aa_validUrls: [URL] {
        let types: NSTextCheckingResult.CheckingType = .link
        
        do {
            let detector = try NSDataDetector(types: types.rawValue)
            let matches = detector.matches(in: self, options: .reportCompletion, range: NSMakeRange(0, self.count))
            return matches.compactMap({$0.url})
        } catch let error {
            debugPrint("AAExtensions:- ", error.localizedDescription)
        }
        
        return []
    }
    
    var aa_toDict: [String: Any]? {
        
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
            } catch {
                debugPrint("AAExtensions:- ", error.localizedDescription)
            }
        }
        return nil
        
    }
    
    var aa_camelCaseToWords: String {
        unicodeScalars.reduce("") {
            if CharacterSet.uppercaseLetters.contains($1) { return ($0 + " " + String($1)) }
            else { return $0 + String($1) }
        }
    }
    
    @available(iOS 12.0, *)
    var aa_detectedLanguage: NLLanguage? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(self)
        return recognizer.dominantLanguage
    }
    
    @available(iOS 12.0, *)
    var aa_recognizeLanguage: NLLanguage {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(self)
        let hypotheses = recognizer.languageHypotheses(withMaximum: 5)
        if let preferred = hypotheses.sorted(by: { $0.value > $1.value }).first {
            return preferred.key
        }
        return .english
    }
}


public extension String {
    
    fileprivate var aa_fileURL: URL { URL(fileURLWithPath: self) }
    
    var aa_pathExtension: String { aa_fileURL.pathExtension }
    
    var aa_lastPathComponent: String { aa_fileURL.lastPathComponent }
    
    var aa_formattedFileSize: String? {
        guard let size = try? FileManager.default.attributesOfItem(atPath: self)[FileAttributeKey.size],
            let fileSize = size as? UInt64 else {
            return nil
        }

        // bytes
        if fileSize < 1023 {
            return String(format: "%lu bytes", CUnsignedLong(fileSize))
        }
        // KB
        var floatSize = Float(fileSize / 1024)
        if floatSize < 1023 {
            return String(format: "%.1f KB", floatSize)
        }
        // MB
        floatSize = floatSize / 1024
        if floatSize < 1023 {
            return String(format: "%.1f MB", floatSize)
        }
        // GB
        floatSize = floatSize / 1024
        return String(format: "%.1f GB", floatSize)
    }
}


public extension String {
    
    //    "abcde"[0] --> "a"
    //    "abcde"[0...2] --> "abc"
    //    "abcde"[2..<4] --> "cd"
    
    subscript(aa i: Int) -> String {
        let idx1 = index(startIndex, offsetBy: i)
        let idx2 = index(idx1, offsetBy: 1)
        return String(self[idx1..<idx2])
    }
    
    subscript (aa r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start ..< end])
    }
    
    subscript (aa r: CountableClosedRange<Int>) -> String {
        let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return String(self[startIndex...endIndex])
    }
}
