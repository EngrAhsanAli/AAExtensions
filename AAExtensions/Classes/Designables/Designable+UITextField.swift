//
//  Designable+UITextField.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

// MARK:- UITextfield IBDesignable
@IBDesignable
public extension UITextField {
    
    @IBInspectable var AAPaddingLeft: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var AAPaddingRight: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
    
    @IBInspectable
    public var AAShouldDismiss: Bool {
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
    public var AAMandatoryView: Bool {
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

