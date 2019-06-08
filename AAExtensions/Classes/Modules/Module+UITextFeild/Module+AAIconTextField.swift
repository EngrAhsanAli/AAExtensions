//
//  Module+AAIconTextField.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 12/05/2019.
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


@available(iOS 9.0, *)
@IBDesignable
open class AAIconTextField: UITextField {
    
    override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return super.leftViewRect(forBounds: bounds)
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    @IBInspectable var rightPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    @IBInspectable var imageMaxHeight: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var color: UIColor = .lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let containerSize = calculateContainerViewSize(for: image)
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: containerSize.width, height: containerSize.height))
            let imageView = UIImageView(frame: .zero)
            containerView.addSubview(imageView)
            setImageViewConstraints(imageView, in: containerView)
            setImageViewProperties(imageView, image: image)
            leftView = containerView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "",
                                                   attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    private func calculateContainerViewSize(for image: UIImage) -> CGSize {
        let imageRatio = image.size.height / image.size.width
        let adjustedImageMaxHeight = imageMaxHeight > self.frame.height ? self.frame.height : imageMaxHeight
        
        var imageSize = CGSize()
        if image.size.height > adjustedImageMaxHeight {
            imageSize.height = adjustedImageMaxHeight
            imageSize.width = imageSize.height / imageRatio
        }
        
        let paddingWidth = leftPadding + rightPadding
        
        let containerSize = CGSize(width: imageSize.width + paddingWidth, height: imageSize.height)
        return containerSize
    }
    
    private func setImageViewConstraints(_ imageView: UIImageView, in containerView: UIView) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -rightPadding).isActive = true
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leftPadding).isActive = true
    }
    
    private func setImageViewProperties(_ imageView: UIImageView, image: UIImage) {
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.tintColor = color
    }
}
