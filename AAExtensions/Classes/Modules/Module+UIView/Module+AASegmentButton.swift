//
//  Module+AASegmentButton.swift
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
open class AASegmentButton: UIView {
    
    @IBInspectable public var leftText: String = "A"
    @IBInspectable public var rightText: String = "B"
    private var shouldSetupConstraints = true
    
    lazy public var buttonLeft: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(self.buttonTrueClicked), for: .touchUpInside)
        btn.isSelected = true
        return btn
    }()
    
    lazy public var buttonRight: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(self.buttonFalseClicked), for: .touchUpInside)
        return btn
    }()
    
    var result: Bool {
        return buttonLeft.isSelected
    }
    var callback : ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override open func updateConstraints() {
        if(shouldSetupConstraints) {
            // AutoLayout constraints
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setTextToButton(buttonLeft, leftText)
        setTextToButton(buttonRight, rightText)
        
        self.addSubview(buttonLeft)
        self.addSubview(buttonRight)
        
        let leadingConstraint = NSLayoutConstraint(item: buttonLeft, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 18)
        let heightConstraint = NSLayoutConstraint(item: buttonLeft, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 34)
        let widthConstraint = NSLayoutConstraint(item: buttonLeft, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
        let verticalConstraint = NSLayoutConstraint(item: buttonLeft, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraints([leadingConstraint, heightConstraint, widthConstraint, verticalConstraint])
        
        let tConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: buttonRight, attribute: .trailing, multiplier: 1, constant: 18)
        let wConstraint = NSLayoutConstraint(item: buttonRight, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
        let hConstraint = NSLayoutConstraint(item: buttonRight, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 34)
        let vConstraint = NSLayoutConstraint(item: buttonRight, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraints([wConstraint, tConstraint, hConstraint, vConstraint])
        
        setBorderColor()
    }
    
    private func setTextToButton(_ button: UIButton, _ value: String) {
        let attrs = NSMutableAttributedString(string: value)
        var range = NSMakeRange(0, 1)
        button.setAttributedTitle(attrs, for: .normal)
        
        let newAttr = NSMutableAttributedString(string: value)
        range = NSMakeRange(0, 1)
        let text = button.titleLabel!.text!
        range = NSMakeRange(0, text.count)
        newAttr.addAttribute(.foregroundColor, value: UIColor.green, range: range)
        button.setAttributedTitle(newAttr, for: .selected)
    }
    
    func toggleSelection() {
        if result {
            buttonFalseClicked()
        } else {
            buttonTrueClicked()
        }
    }
    
    func setBorderColor() {
        [buttonLeft, buttonRight].forEach { (button) in
            if (button.isSelected) {
                button.AABorderColor = UIColor.green
            } else {
                button.AABorderColor = UIColor.gray
            }
        }
    }
    
    @objc private func buttonTrueClicked() {
        buttonLeft.isSelected = true
        buttonRight.isSelected = false
        setBorderColor()
        callback?(result)
    }
    
    @objc private func buttonFalseClicked() {
        buttonRight.isSelected = true
        buttonLeft.isSelected = false
        setBorderColor()
        callback?(result)
    }
}
