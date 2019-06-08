//
//  Designable+UITextField.swift
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


// MARK:- UITextfield IBDesignable
@IBDesignable
public extension UITextField {
    
    @IBInspectable var AAPaddingLeft: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftViewMode = .always
        }
    }
    
    @IBInspectable var AAPaddingRight: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            rightView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightViewMode = .always
        }
    }
    
    @IBInspectable
    var AAShouldDismiss: Bool {
        get {
            return self.AAShouldDismiss
        }
        set (value)  {
            if value {
                self.addTarget(nil, action:#selector(UIView.endEditing(_ :)), for:.editingDidEndOnExit)
            }
        }
    }
    
    @IBInspectable var AAMaxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &AA_AssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &AA_AssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc private func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > AAMaxLength
            else {
                return
        }
        let selection = selectedTextRange
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: AAMaxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        selectedTextRange = selection
    }
    
    @IBInspectable
    var AAMandatoryView: Bool {
        get {
            return self.AAMandatoryView
        }
        set (value)  {
            if value {
                let astericLabel = UILabel()
                astericLabel.text = "*"
                astericLabel.textColor = .red
                self.addSubview(astericLabel)
                astericLabel.sizeToFit()
                astericLabel.font = UIFont.boldSystemFont(ofSize: 20)
                astericLabel.translatesAutoresizingMaskIntoConstraints = false
                self.aa_bindConstraints(astericLabel, bindAttrs: [.centerY, .trailing])
            }
        }

    }

}

