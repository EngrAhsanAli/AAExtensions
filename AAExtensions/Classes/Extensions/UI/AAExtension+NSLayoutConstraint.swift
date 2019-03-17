//
//  Extension+NSLayoutConstraint.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

// MARK: - NSLayoutConstraint
public extension NSLayoutConstraint {
    func aa_swap( _ with: NSLayoutConstraint) {
        let _withConstant = with.constant
        with.constant = self.constant
        self.constant = _withConstant
    }
}
