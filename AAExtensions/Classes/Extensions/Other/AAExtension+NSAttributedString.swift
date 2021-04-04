//
//  AAExtension+NSAttributedString.swift
//  AAExtensions
//
//  Created by Ahsan Ali on 03/06/2019.
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

// MARK: - NSAttributedString
public extension NSAttributedString {
    
    convenience init?(htmlString html: String, font: UIFont? = nil, color: UIColor?, useDocumentFontSize: Bool = true) {
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let string = html.replacingOccurrences(of: "\n", with: "<br>")
        let data = string.data(using: .utf8, allowLossyConversion: true)
        guard (data != nil), let fontFamily = font?.familyName, let attr = try? NSMutableAttributedString(data: data!, options: options, documentAttributes: nil) else {
            try? self.init(data: data ?? Data(string.utf8), options: options, documentAttributes: nil)
            return
        }
        
        let fontSize: CGFloat? = useDocumentFontSize ? nil : font!.pointSize
        let range = NSRange(location: 0, length: attr.length)
        attr.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { attrib, range, _ in
            if let htmlFont = attrib as? UIFont {
                let traits = htmlFont.fontDescriptor.symbolicTraits
                var descrip = htmlFont.fontDescriptor.withFamily(fontFamily)
                
                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitBold)!
                }
                
                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitItalic)!
                }
                
                attr.addAttribute(.font, value: UIFont(descriptor: descrip, size: fontSize ?? htmlFont.pointSize), range: range)
                if let color = color {
                    attr.addAttribute(.foregroundColor, value: color, range: range)
                }
                
            }
        }
        
        self.init(attributedString: attr)
    }
    
    convenience init(aa_withText text: String, keywords: String, color: UIColor) {
        let allString = NSMutableAttributedString(string: text)
        
        keywords.components(separatedBy: " ").forEach({ (word) in
            let string = NSMutableAttributedString(string: text)
            if let range = string.string.range(of: word, options: .caseInsensitive) {
                let nsRange = string.string.aa_nsRange(from: range)
                (string.string as NSString).substring(with: nsRange)
                allString.addAttributes([
                    NSAttributedString.Key.foregroundColor: color as Any
                    ], range: NSRange(location: nsRange.location, length: word.count))
            }
        })
        self.init(attributedString: allString)
    }
    
    convenience init(aa_pairAttibutes strings: [String], fonts: [UIFont], colors: [UIColor]) {
        
        guard (strings.count == fonts.count) && (fonts.count == colors.count) else {
            fatalError()
        }
        
        let mutableAttributedString = NSMutableAttributedString()
        
        for i in 0...strings.count - 1 {
            let text = strings[i]
            let font = fonts[i]
            let color = colors[i]
            
            let attibutes = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: color
            ]
            let attString = NSAttributedString(string: text, attributes: attibutes)
            mutableAttributedString.append(attString)
        }
        
        
        self.init(attributedString: mutableAttributedString)
    }
}


public extension NSMutableAttributedString {
    
    func aa_setAsLink(textToFind:String, linkURL:String, font: UIFont, color: UIColor = .blue) {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            _ = NSMutableAttributedString(string: textToFind)
            
            let urlAttributes: [NSAttributedString.Key: Any] = [
                .attachment: URL(string: linkURL) as Any,
                .font: font,
                .foregroundColor: color,
                .underlineColor: color,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            
            self.setAttributes(urlAttributes, range: foundRange)
        }
    }
    
    func aa_embedIcon(image: UIImage, color: UIColor?, spacing: Int = 2, size: CGFloat?, baseline: Int? = nil, isLeft: Bool) {
        let attachment = NSTextAttachment()
        if let size = size {
            let height = image.aa.height(forWidth: size)
            attachment.bounds = .init(x: 0, y: 0, width: size, height: height)
        }
        var _image = image
        if let color = color, let tintImage = image.aa.tint(with: color) {
            _image = tintImage
        }
        attachment.image = _image
        let attachmentString = NSAttributedString(attachment: attachment)
        
        if let baseline = baseline {
            let text = string
            let range = NSRange(text.startIndex..<text.endIndex, in: text)
            addAttribute(.baselineOffset, value: baseline, range: range)
        }
        
        let spacing = NSAttributedString(string: .init(repeating: " ", count: spacing))
        if isLeft {
            insert(spacing, at: 0)
            insert(attachmentString, at: 0)
        }
        else {
            append(spacing)
            append(attachmentString)
        }
        
    }
}
