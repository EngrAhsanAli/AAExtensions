//
//  Extension+UIButton.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

// MARK:- UIButton
public extension UIButton {
    
    func initLeftIcon(_ string: String? = nil,
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
