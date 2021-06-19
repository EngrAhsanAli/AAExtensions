//
//  Extension+UIFont.swift
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


// MARK:- UIFont
public extension UIFont {
    
    class func registerFont(withFilenameString filenameString: String, bundle: Bundle) {
        
        guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
            print("\(AA_TAG) Failed to register font - path for resource not found.")
            return
        }
        
        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("\(AA_TAG) Failed to register font - font data could not be loaded.")
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("\(AA_TAG) Failed to register font - data provider could not be loaded.")
            return
        }
        
        guard let font = CGFont(dataProvider) else {
            print("\(AA_TAG) Failed to register font - font could not be loaded.")
            return
        }
        
        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(font, &errorRef) == false) {
            print("\(AA_TAG) Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
    
    class func aa_fetchFont(from url: URL, completion: ((UIFont?) -> ())?) {
        URLSession(configuration: .default).dataTask(with: url,
                         completionHandler: { (data, response, error) in
                            guard error == nil,
                                let data = data,
                                (response as? HTTPURLResponse)?.statusCode == 200,
                                let ctFontDescriptor = CTFontManagerCreateFontDescriptorFromData(data as CFData) else {
                                    completion?(nil)
                                    return
                            }
                            // Create CTFont from the Font Descriptor and convert it to UIFont.
                            let font: UIFont = CTFontCreateWithFontDescriptor(ctFontDescriptor, 0.0, nil) as UIFont
                            completion?(font)
        }).resume()
    }
}

@available(iOS 8.2, *)
public extension UIFont.Weight {
    
    var aa_string: String? {
        switch self {
        case .regular: return "Regular"
        case .bold: return "Bold"
        case .medium: return "Medium"
        case .light: return "Light"
        case .heavy: return "Heavy"
        case .semibold: return "Semibold"
        case .thin: return "Thin"
        case .ultraLight: return "UltraLight"
        default:  return nil
        }
    }
}

public extension AA where Base: UIFont {
    
    var bold: UIFont { with(.traitBold) }
    
    var italic: UIFont { with(.traitItalic) }
    
    var boldItalic: UIFont { with([.traitBold, .traitItalic]) }
    
    var weight: UIFont.Weight {
        guard let weightNumber = traits[.weight] as? NSNumber else { return .regular }
        let weightRawValue = CGFloat(weightNumber.doubleValue)
        let weight = UIFont.Weight(rawValue: weightRawValue)
        return weight
    }
    
    private var traits: [UIFontDescriptor.TraitKey: Any] {
        return base.fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
            ?? [:]
    }
    
    private func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = base.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(base.fontDescriptor.symbolicTraits)) else {
            return base
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
    
    private func without(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = base.fontDescriptor.withSymbolicTraits(base.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
            return base
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
