//
//  Module+AABindableBarButton.swift
//  AAExtensions
//
//  Created by Muhammad Ahsan Ali on 2020/06/17.
//

import UIKit


public class AABindableBarButton: UIBarButtonItem {
    private var actionHandler: (() -> ())?
    
    public convenience init(image: UIImage?, actionHandler: (() -> ())?) {
        self.init(image: image, style: .plain, target: nil, action: #selector(barButtonItemPressed))
        self.target = self
        self.actionHandler = actionHandler
    }
    
    public convenience init(systemItem: UIBarButtonItem.SystemItem, actionHandler: (() -> ())?) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: #selector(barButtonItemPressed))
        self.target = self
        self.actionHandler = actionHandler
    }
    public convenience init(title: String?, font: UIFont, foregroundColor: UIColor, actionHandler: (() -> ())?) {
        self.init(title: title, style: .plain, target: nil, action: #selector(barButtonItemPressed))
        self.target = self
        
        setTitleTextAttributes([
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor : foregroundColor,
        ], for: .normal)
        
        setTitleTextAttributes([
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor : foregroundColor,
        ], for: .highlighted)
        
        self.actionHandler = actionHandler
    }
    
    @objc func barButtonItemPressed(sender: UIBarButtonItem) {
        actionHandler?()
    }
}

final class BindableGestureRecognizer: UITapGestureRecognizer {
    
    var _action: AACompletionVoid
    
    init(_ action: @escaping AACompletionVoid) {
        self._action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }
    
    @objc private func execute() {
        _action()
    }
}

