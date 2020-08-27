//
//  AAExtensions+UISearchBar.swift
//  AAExtensions
//
//  Created by Muhammad Ahsan Ali on 2020/08/25.
//

public extension UISearchBar {
    
    func aa_clearBackgroundColor() {
        guard let backgroundClass: AnyClass = NSClassFromString("UISearchBarBackground") else { return }
        subviews.forEach { (view) in
            for subview in view.subviews where subview.isKind(of: backgroundClass) {
                subview.alpha = 0
            }
        }
    }
    
}
