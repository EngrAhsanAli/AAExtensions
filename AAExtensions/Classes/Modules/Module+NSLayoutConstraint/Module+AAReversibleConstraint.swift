//
//  Module+AAReversibleConstraint.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//


public class AAReversibleConstraint: NSLayoutConstraint {
    
    @IBInspectable
    public var isHidden: Bool = false {
        didSet (value)  {
            if value {
                _constant = self.constant
                self.hide()
            }
        }
    }
    
    var _constant: CGFloat = 0
    
    override public var constant: CGFloat {
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
    
    open func show() {
        guard !isShowing else { return }
        super.constant = _constant
    }
    
    open func hide() {
        guard isShowing else { return }
        super.constant = 0
    }
    
    open var isShowing: Bool {
        return super.constant != 0
    }
    
    open func toggle() {
        isShowing ? hide() : show()
    }
    
    open func showHide(_ showView: Bool) {
        showView ? show() : hide()
    }
    
}
