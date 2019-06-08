//
//  Module+AAStackViewSeparator.swift
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


@available(iOS 9.0, *)
@IBDesignable open class AAStackViewSeparator: UIStackView {
    
    @IBInspectable open var leftSide: UIColor? = nil
    @IBInspectable open var rightSide: UIColor? = nil
    @IBInspectable open var topSide: UIColor? = nil
    @IBInspectable open var bottomSide: UIColor? = nil
    @IBInspectable open var separatorWidth: CGFloat = 0.5
    
    @IBInspectable private var separatorTopPadding: CGFloat = 0 {
        didSet {
            separatorInsets.top = separatorTopPadding
        }
    }
    @IBInspectable private var separatorBottomPadding: CGFloat = 0 {
        didSet {
            separatorInsets.bottom = separatorBottomPadding
        }
    }
    @IBInspectable private var separatorLeftPadding: CGFloat = 0 {
        didSet {
            separatorInsets.left = separatorLeftPadding
        }
    }
    @IBInspectable private var separatorRightPadding: CGFloat = 0 {
        didSet {
            separatorInsets.right = separatorRightPadding
        }
    }

    var separatorInsets: UIEdgeInsets = .zero {
        didSet {
            invalidateSeparators()
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        invalidateSeparators()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    private func invalidateSeparators() {
        
        arrangedSubviews.forEach { (stackedView) in
            
            if let side = topSide {
                stackedView.aa_addTopBorderWithColor(color: side, width: separatorWidth, paddingX: separatorInsets.top, paddingY: separatorInsets.bottom)
            } else if let side = leftSide {
                stackedView.aa_addLeftBorderWithColor(color: side, width: separatorWidth, paddingX: separatorInsets.left, paddingY: separatorInsets.right)
            } else if let side = rightSide {
                stackedView.aa_addRightBorderWithColor(color: side, width: separatorWidth, paddingX: separatorInsets.right, paddingY: separatorInsets.left)
            } else if let side = bottomSide {
                stackedView.aa_addBottomBorderWithColor(color: side, width: separatorWidth, paddingX: separatorInsets.bottom, paddingY: separatorInsets.top)
            }
            
        }
        
    }
}
