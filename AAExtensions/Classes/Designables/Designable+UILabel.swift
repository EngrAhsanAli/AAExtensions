//
//  Designable+UILabel.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

// MARK:- UILabel IBDesignable
@IBDesignable
public extension UILabel {
    
    @IBInspectable
    public var AAFixFont: Bool {
        get {
            return self.AAFixFont
        }
        set (value)  {
            guard value else { return }
            self.minimumScaleFactor = 0.1
            self.adjustsFontSizeToFitWidth = true
            self.lineBreakMode = .byClipping
            self.numberOfLines = 0
        }
    }
    
}
