//
//  Module+AARoundedButton.swift
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


/// AARoundedButton
open class AARoundedButton: UIButton {
    
    public var buttonColor: UIColor = .blue {
        didSet {
            self.layer.borderColor = buttonColor.cgColor
            self.setTitleColor(buttonColor, for: .normal)
        }
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderWidth = 2.0
        self.clipsToBounds = true
        self.setTitleColor(.white, for: .highlighted)
        (buttonColor = buttonColor)
    }
    
    override open var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? buttonColor : .clear
        }
    }
    
}
