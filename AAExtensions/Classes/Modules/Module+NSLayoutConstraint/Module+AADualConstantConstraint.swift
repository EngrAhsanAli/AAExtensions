//
//  Module+AADualConstantConstraint.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 16/09/2019.
//

/// MARK:- DualConstantConstraint
public class AADualConstantConstraint: NSLayoutConstraint {
    
    /// Default Nib constant backup
    private var _constant: CGFloat = 0
    
    @IBInspectable
    public var otherConstraint: CGFloat = 0
    
    override open var constant: CGFloat {
        set {
            super.constant = newValue
        }
        get {
            if super.constant != 0 {
                _constant = super.constant
            }
            return super.constant
        }
    }
    
    /// Sets the desired constraint
    ///
    /// - Parameter isDefault: NIB default constraint
    open func setConstraint(_ isDefault: Bool) {
        if isDefault {
            super.constant = _constant
        }
        else {
            super.constant = otherConstraint
        }
    }
    
}

