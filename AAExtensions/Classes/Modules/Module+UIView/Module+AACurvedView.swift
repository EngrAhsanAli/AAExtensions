//
//  Module+AACurvedView.swift
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


@IBDesignable
open class AACurvedView: UIView {
    var isInterfaceBuilder: Bool = false
    
    override open func prepareForInterfaceBuilder() {
        self.isInterfaceBuilder = true
    }
    
    @IBInspectable open var fillColor: UIColor = .white {
        didSet {
            curvedLayer.fillColor = fillColor.cgColor
        }
    }
    
    lazy var curvedLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = fillColor.cgColor
        layer.strokeColor = UIColor.clear.cgColor
        layer.lineWidth = 0
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        if !isInterfaceBuilder {
            self.layer.insertSublayer(curvedLayer, at: 0)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        curvedLayer.path = pathOfArc(within: bounds.size)?.cgPath
    }
    
    func pathOfArc(within size: CGSize) -> UIBezierPath? {
        if size.width == 0 || size.height <= 0 {
            return nil
        }
        let theta: CGFloat = .pi - atan2(size.width / 2.0, size.height) * 2.0
        let radius: CGFloat = bounds.size.height / (1.0 - cos(theta))
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        let halfPI = CGFloat(Double.pi/2)
        path.addArc(withCenter: CGPoint(x: size.width / 2.0, y: -radius + size.height), radius: radius, startAngle: halfPI + theta, endAngle: halfPI - theta, clockwise: false)
        path.close()
        return path
    }
    
}
