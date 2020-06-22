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
    
    @objc func barButtonItemPressed(sender: UIBarButtonItem) {
        actionHandler?()
    }
}

final class BindableGestureRecognizer: UITapGestureRecognizer {
    
    var _action: AACompletionVoid
    
    init(_ target: Any, action: @escaping AACompletionVoid) {
        self._action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }
    
    @objc private func execute() {
        _action()
    }
}

