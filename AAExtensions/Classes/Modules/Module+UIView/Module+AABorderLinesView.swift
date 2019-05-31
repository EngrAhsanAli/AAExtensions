//
//  Module+AABorderLinesView.swift
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


@IBDesignable
open class AABorderLinesView: UIView {
        
    @IBInspectable open var paddingX: CGFloat = 0
    @IBInspectable open var paddingY: CGFloat = 0
    @IBInspectable open var lineWidth: CGFloat = 1
    @IBInspectable open var leftSide: UIColor? = nil
    @IBInspectable open var rightSide: UIColor? = nil
    @IBInspectable open var topSide: UIColor? = nil
    @IBInspectable open var bottomSide: UIColor? = nil
    
    var isInterfaceBuilder: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func prepareForInterfaceBuilder() {
        self.isInterfaceBuilder = true
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if !isInterfaceBuilder {
            if let side = topSide {
                aa_addTopBorderWithColor(color: side, width: lineWidth, paddingX: paddingX, paddingY: paddingY)
            } else if let side = leftSide {
                aa_addLeftBorderWithColor(color: side, width: lineWidth, paddingX: paddingX, paddingY: paddingY)
            } else if let side = rightSide {
                aa_addRightBorderWithColor(color: side, width: lineWidth, paddingX: paddingX, paddingY: paddingY)
            } else if let side = bottomSide {
                aa_addBottomBorderWithColor(color: side, width: lineWidth, paddingX: paddingX, paddingY: paddingY)
            }
        }
    }
}
