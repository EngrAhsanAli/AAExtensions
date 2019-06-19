//
//  Extension+UIButton.swift
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


// MARK:- UIButton
public extension UIButton {
    
    func aa_LeftIcon(_ string: String? = nil,
                      icon: String,
                      selected: String,
                      color: UIColor,
                      unselectedColor: UIColor,
                      iconFont: UIFont,
                      textFont: UIFont) {
        
        let buttonText = string ?? self.titleLabel!.text ?? ""
        self.contentHorizontalAlignment = .left
        
        self.tintColor = self.titleLabel?.textColor
        
        let range = NSMakeRange(0, 1)
        let textRange = NSMakeRange(1, buttonText.count + 1)
        let attrs = NSMutableAttributedString(string: "\(icon) \(buttonText)")
        attrs.addAttribute(.baselineOffset, value: 3, range: textRange)
        attrs.addAttribute(.font, value: iconFont, range: range)
        attrs.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        self.setAttributedTitle(attrs, for: .normal)
        
        let attrsS = NSMutableAttributedString(string: "\(selected) \(buttonText)")
        attrsS.addAttribute(.baselineOffset, value: 3, range: textRange)
        attrsS.addAttribute(.font, value: textFont, range: range)
        attrsS.addAttribute(NSAttributedString.Key.foregroundColor, value: unselectedColor , range: range)
        self.setAttributedTitle(attrsS, for: .selected)
        self.addTarget(self, action: #selector(self.leftIconClicked), for: .touchUpInside)
    }
    
    @objc private func leftIconClicked() {
        self.isSelected = !self.isSelected
    }
}
