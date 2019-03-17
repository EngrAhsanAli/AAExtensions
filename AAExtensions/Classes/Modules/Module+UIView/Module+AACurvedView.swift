//
//  Module+AACurvedView.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

@IBDesignable
public class AACurvedView: UIView {
    var isInterfaceBuilder: Bool = false
    
    override public func prepareForInterfaceBuilder() {
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        if !isInterfaceBuilder {
            self.layer.insertSublayer(curvedLayer, at: 0)
        }
    }
    
    override public func layoutSubviews() {
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
