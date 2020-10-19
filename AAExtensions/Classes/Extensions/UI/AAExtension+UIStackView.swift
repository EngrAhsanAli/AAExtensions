//
//  Extension+UIStackView.swift
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


// MARK:- StackView
@available(iOS 9.0, *)
public extension UIStackView {
    func aa_addBackgroundColor(_ color: UIColor) {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = color
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subview, at: 0)
    }
    
    func aa_removeArrangedSubviews(removeConstraints: Bool) {
        let removedSubviews = arrangedSubviews.reduce([]) { (sum, next) -> [UIView] in
            self.removeArrangedSubview(next)
            return sum + [next]
        }
        if removeConstraints {
            NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        }
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    func aa_setClickListner(_ callback: @escaping ((Int) -> ())) {
        isUserInteractionEnabled = true
        aa_addTapGesture(self) {
            guard let sender = self.gestureRecognizers?.filter({ ($0 as? UITapGestureRecognizer != nil) }).first else {
                return
            }
            let view = sender.view
            let loc = sender.location(in: view)
            guard let subview = view?.hitTest(loc, with: nil) else { return }
            callback(subview.tag)
            
        }
        arrangedSubviews.enumerated().forEach { $0.element.tag = $0.offset }
        
    }
}
