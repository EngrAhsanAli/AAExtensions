//
//  Module+AABackButton.swift
//  AAExtensions
//
//  Created by MacBook Pro on 18/03/2019.
//

public class AABackButton : UIButton {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
    }
    
    @objc private func backButtonAction() {
        
        guard let root = UIApplication.shared.keyWindow?.rootViewController else { return }
        
        if let vc = root.presentedViewController as? UINavigationController {
            vc.popViewController(animated: true)
        }
        else if let vc = root as? UINavigationController {
            vc.popViewController(animated: true)
        }
        else {
            root.presentedViewController?.dismiss(animated: true, completion: nil) // Dismiss
        }
        
    }
    
    
}
