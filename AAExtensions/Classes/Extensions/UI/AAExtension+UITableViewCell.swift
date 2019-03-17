//
//  Extension+UITableViewCell.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

// MARK:- UITableViewCell
public extension UITableViewCell {
    var aa_selectionColor: UIColor {
        set {
            let view = UIView()
            view.backgroundColor = newValue
            self.selectedBackgroundView = view
        }
        get {
            return self.selectedBackgroundView?.backgroundColor ?? .clear
        }
    }
}



