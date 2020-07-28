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
    
    func setFontIcon(string: (String?, String?)?,
                      icons: (String, String?),
                      color: (UIColor?, UIColor?)?,
                      textColor: (UIColor?, UIColor?)?,
                      iconFont: UIFont,
                      isLeft: Bool) {
        
        let buttonText = string?.0 ?? base.title(for: .normal) ?? ""
        let selectedText = string?.1 ?? string?.0 ?? base.title(for: .selected) ?? buttonText
        let normalColor = textColor?.0 ?? base.titleColor(for: .normal)
        let selectedColor = textColor?.1 ?? textColor?.0 ?? base.titleColor(for: .selected)
        
        let titleString, selectedString: String
        let icon = icons.0
        let selectedIcon = icons.1 ?? icons.0
        let textRange, textRangeSelected: NSRange
        
        if isLeft {
            titleString = "\(icon) \(buttonText)"
            selectedString = "\(selectedIcon) \(selectedText)"
        }
        else {
            titleString = "\(buttonText) \(icon)"
            selectedString = "\(selectedText) \(selectedIcon)"
        }
        
        
        textRange = NSRange(titleString.range(of: buttonText)!, in: titleString)
        textRangeSelected = NSRange(selectedString.range(of: selectedText)!, in: selectedString)
        
        let rangeIcon = NSRange(titleString.range(of: icon)!, in: titleString)
        
        let attrs = NSMutableAttributedString(string: titleString)
        attrs.addAttribute(.baselineOffset, value: 3, range: textRange)
        attrs.addAttribute(.font, value: iconFont, range: rangeIcon)
        if let color = color, let normalColor = color.0 {
            attrs.addAttribute(NSAttributedString.Key.foregroundColor, value: normalColor , range: rangeIcon)
        }
        attrs.addAttribute(NSAttributedString.Key.foregroundColor, value: normalColor as Any , range: textRange)
        base.setAttributedTitle(attrs, for: .normal)
        
        let attrsS = NSMutableAttributedString(string: selectedString)
        attrsS.addAttribute(.baselineOffset, value: 3, range: textRangeSelected)
        attrsS.addAttribute(NSAttributedString.Key.foregroundColor, value: selectedColor as Any  , range: textRangeSelected)
        attrsS.addAttribute(.font, value: iconFont, range: rangeIcon)
        if let color = color, let normalColor = color.1 ?? color.0 {
            attrsS.addAttribute(NSAttributedString.Key.foregroundColor, value: normalColor, range: rangeIcon)
        }
        base.setAttributedTitle(attrsS, for: .selected)
        
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
                            self.base.isSelected.aa_toggle()
                            animation()
        }, completion: nil)
    }
    
}

public extension UIBarButtonItem {
    
    var aa_view: UIView? {
        value(forKey: "view") as? UIView
    }
    
}
