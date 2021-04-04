//
//  AAExtension+UITextField.swift
//  AAExtensions
//
//  Created by Ahsan ALI on 25/05/2019.
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

public extension AA where Base: UITextField {
    
    func hintColor(_ color: UIColor) {
        guard let holder = base.placeholder, !holder.isEmpty else { return }
        base.attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color])
    }
    
    func setIcon(with size: CGFloat = 18, padding: CGFloat = 8, image: UIImage, isRight: Bool = true) {
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size))
        let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
        iconView.image = image
        outerView.addSubview(iconView)
        
        if isRight {
            base.rightView = outerView
            base.rightViewMode = .always
        }
        else {
            base.leftView = outerView
            base.leftViewMode = .always
        }
    }
    
    func inputDatePicker(completion: ((String) -> ())?) {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        base.inputView = datePicker
        
        let toolBar = UIToolbar()
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = AABindableBarButton(systemItem: .cancel) {
            base.resignFirstResponder()
        }
        let doneBtn = AABindableBarButton(systemItem: .done) {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            base.text = dateformatter.string(from: datePicker.date)
            base.resignFirstResponder()
            completion?(base.text ?? "")
        }
        
        toolBar.setItems([cancel, flexible, doneBtn], animated: false)
        toolBar.sizeToFit()
        base.inputAccessoryView = toolBar
        
    }
    
}
