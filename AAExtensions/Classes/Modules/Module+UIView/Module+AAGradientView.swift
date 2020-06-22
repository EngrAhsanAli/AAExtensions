//
//  Module+AAGradientView.swift
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


public struct AAGradientModel {
    public let colors: [UIColor]
    public let startPoint, endPoint: AAPoint
    public let locations: [NSNumber]
    
    public init(colors: [UIColor], startPoint: AAPoint, endPoint: AAPoint, locations: [NSNumber]) {
        self.colors = colors
        self.locations = locations
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}



@available(iOS 9.0, *)
public class AAGradientView: UIView {
    
    weak var gradientLayer: CAGradientLayer!
    
    var model: AAGradientModel!

    public convenience init(_ model: AAGradientModel) {
        
        self.init(frame: .zero)
        self.model = model
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "AAGradientView"
        gradientLayer.frame = frame
        layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
        set()
        backgroundColor = .clear
    }

    func set() {
        
        gradientLayer.colors = model.colors.map { $0.cgColor }
        gradientLayer.startPoint = model.startPoint.point
        gradientLayer.endPoint = model.endPoint.point
        gradientLayer.locations = model.locations
    }

    open func setupConstraints() {
        guard let parentView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
        parentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        parentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let gradientLayer = gradientLayer else { return }
        gradientLayer.frame = frame
        superview?.addSubview(self)
        superview?.sendSubviewToBack(self)
    }
}



// MARK: - UINavigationController
public extension AA where Base: UIViewController {
    
    @available(iOS 9.0, *)
    func setGradientNavigation(_ model: AAGradientModel) {
        guard let backgroundView = base.navigationController?.navigationBar.value(forKey: "backgroundView") as? UIView else {
            return
        }
        
        guard let gradientView = backgroundView.subviews.first(where: { $0 is AAGradientView }) as? AAGradientView else {
            let gradientView = AAGradientView(model)
            backgroundView.addSubview(gradientView)
            gradientView.setupConstraints()
            return
        }
        
        gradientView.set()
    }


}
