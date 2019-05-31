//
//  Module+AAVerticalAlignLabel.swift
//  AAExtensions
//
//  Created by Ahsan Ali on 30/05/2019.
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

@IBDesignable
open class AAVerticalAlignLabel: UILabel {
    
    @IBInspectable var alignmentCode: Int = 0 {
        didSet {
            applyAlignmentCode()
        }
    }
    
    func applyAlignmentCode() {
        switch alignmentCode {
        case 0:
            verticalAlignment = .top
        case 1:
            verticalAlignment = .topcenter
        case 2:
            verticalAlignment = .middle
        case 3:
            verticalAlignment = .bottom
        default:
            break
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.applyAlignmentCode()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        self.applyAlignmentCode()
    }
    
    enum VerticalAlignment {
        case top
        case topcenter
        case middle
        case bottom
    }
    
    var verticalAlignment : VerticalAlignment = .top {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override open func textRect(forBounds bounds: CGRect, limitedToNumberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: limitedToNumberOfLines)
        
        if #available(iOS 9.0, *) {
            if UIView.userInterfaceLayoutDirection(for: .unspecified) == .rightToLeft {
                switch verticalAlignment {
                case .top:
                    return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
                case .topcenter:
                    return CGRect(x: self.bounds.size.width - (rect.size.width / 2), y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
                case .middle:
                    return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
                case .bottom:
                    return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
                }
            } else {
                switch verticalAlignment {
                case .top:
                    return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
                case .topcenter:
                    return CGRect(x: (self.bounds.size.width / 2 ) - (rect.size.width / 2), y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
                case .middle:
                    return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
                case .bottom:
                    return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
                }
            }
        } else {
            // Fallback on earlier versions
            return rect
        }
    }
    
    override open func drawText(in rect: CGRect) {
        let r = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: r)
    }
}
