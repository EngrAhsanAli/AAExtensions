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
public extension AA where Base: UIButton {
    
    func setFontIcon(string: String?,
                        icon: String,
                        iconColor: UIColor? = nil,
                        textColor: UIColor?,
                        iconFont: UIFont,
                        textFont: UIFont,
                        state: UIControl.State = .normal,
                        baseline: Int = 3,
                        isLeft: Bool) {
        
        let buttonText = string ?? base.title(for: state) ?? " "
        let normalColor = textColor ?? base.titleColor(for: state)
        let titleString: String
        if isLeft { titleString = .localizedStringWithFormat("%@ \(icon)", buttonText) }
        else { titleString = .localizedStringWithFormat("\(icon) %@", buttonText) }
        let textRange = NSRange(titleString.range(of: buttonText)!, in: titleString)
        let rangeIcon = NSRange(titleString.range(of: icon)!, in: titleString)
        
        let attrs = NSMutableAttributedString(string: titleString)
        attrs.addAttribute(.baselineOffset, value: baseline, range: textRange)
        attrs.addAttribute(.font, value: textFont, range: textRange)
        attrs.addAttribute(.font, value: iconFont, range: rangeIcon)
        if let textColor = textColor {
            attrs.addAttribute(.foregroundColor, value: textColor as Any , range: textRange)
        }
        if let iconColor = iconColor {
            attrs.addAttribute(.foregroundColor, value: iconColor , range: rangeIcon)
        }
        else {
            attrs.addAttribute(.foregroundColor, value: normalColor as Any , range: .init(location: 0, length: buttonText.count))
        }
        base.setAttributedTitle(attrs, for: state)
        
    }
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        base.clipsToBounds = true
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            base.setBackgroundImage(colorImage, for: forState)
        }
    }
    
    func animateSelection(_ animation: @escaping (() -> ())) {
        UIView.transition(with: base, duration: 0.3,
                          options: base.isSelected ? .transitionFlipFromBottom : .transitionFlipFromTop,
                          animations: {
                            self.base.isSelected.toggle()
                            animation()
        }, completion: nil)
    }
    
}
