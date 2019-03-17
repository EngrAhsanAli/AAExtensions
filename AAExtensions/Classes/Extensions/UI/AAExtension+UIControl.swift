//
//  Extension+UIControl.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

// MARK:- UIControl
public extension UIControl {
    func aa_addAction(for controlEvents: UIControl.Event, _ closure: @escaping ()->()) {
        let sleeve = AAClosureSleeve(closure)
        addTarget(sleeve, action: #selector(AAClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
