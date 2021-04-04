//
//  Module+AAPaddingLabel.swift
//  AAExtensions
//
//  Created by Muhammad Ahsan Ali on 2021/04/04.
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
open class AAPaddingLabel: UILabel {
    
    @IBInspectable open var topInset: CGFloat = 0.0
    @IBInspectable open var leftInset: CGFloat = 0.0
    @IBInspectable open var bottomInset: CGFloat = 0.0
    @IBInspectable open var rightInset: CGFloat = 0.0
    
    var insets: UIEdgeInsets {
        get { .init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset) }
        set {
            topInset = newValue.top
            leftInset = newValue.left
            bottomInset = newValue.bottom
            rightInset = newValue.right
        }
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var adjSize = super.sizeThatFits(size)
        adjSize.width += leftInset + rightInset
        adjSize.height += topInset + bottomInset
        return adjSize
    }
    
    open override var intrinsicContentSize: CGSize {
        let systemContentSize = super.intrinsicContentSize
        let adjustSize = CGSize(width: systemContentSize.width + leftInset + rightInset, height: systemContentSize.height + topInset +  bottomInset)
        if adjustSize.width > preferredMaxLayoutWidth && preferredMaxLayoutWidth != 0 {
            let constraintSize = CGSize(width: bounds.width - (leftInset + rightInset), height: .greatestFiniteMagnitude)
            let newSize = super.sizeThatFits(constraintSize)
            return CGSize(width: systemContentSize.width, height: ceil(newSize.height) + topInset + bottomInset)
        } else {
            return adjustSize
        }
    }
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
}
