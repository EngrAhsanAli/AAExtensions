//
//  Module+AABindableBarButton.swift
//  AAExtensions
//
//  Created by Muhammad Ahsan Ali on 2020/06/17.
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
        setTitleTextAttributes([.font : font, .foregroundColor : foregroundColor], for: .normal)
        setTitleTextAttributes([.font : font, .foregroundColor : foregroundColor], for: .highlighted)
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

