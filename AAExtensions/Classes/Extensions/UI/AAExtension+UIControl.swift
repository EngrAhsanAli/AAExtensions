//
//  Extension+UIControl.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
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

private class ClosureSleeve<T> {
    let closure: ((T) -> Void)?
    let sender: T
    
    init (sender: T, _ closure: ((T) -> Void)?) {
        self.closure = closure
        self.sender = sender
    }
    
    @objc func invoke() {
        closure?(sender)
    }
}

public extension AA where Base: UIControl {
    
    func addAction(for controlEvent: UIControl.Event = .touchUpInside, _ closure: ((UIControl) -> Void)?) {
        let previousSleeve = objc_getAssociatedObject(base, String(controlEvent.rawValue))
        objc_removeAssociatedObjects(previousSleeve as Any)
        base.removeTarget(previousSleeve, action: nil, for: controlEvent)
        
        let sleeve = ClosureSleeve<UIControl>(sender: base, closure)
        base.addTarget(sleeve, action: #selector(ClosureSleeve<Self>.invoke), for: controlEvent)
        objc_setAssociatedObject(base, String(controlEvent.rawValue), sleeve, .OBJC_ASSOCIATION_RETAIN)
    }
    
}

