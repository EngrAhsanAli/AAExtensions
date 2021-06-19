//
//  Extension+UIView.swift
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

// MARK:- UIView
public extension UIView {
    
    static func fromNib<A: UIView>(nibName name: String, bundle: Bundle = .main) -> A? {
        let nibViews = bundle.loadNibNamed(name, owner: self, options: nil)
        return nibViews?.first as? A
    }
    
}

public extension AA where Base: UIView {

    var viewController: UIViewController? {
        weak var parentResponder: UIResponder? = base
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func updateTableView() {
        var superView = base.superview
        while (superView != nil) {
            if let tableView = superView as? UITableView {
                tableView.beginUpdates()
                tableView.endUpdates()
                break
            }
            superView = superView?.superview
        }
    }
    
    func addDashedLine(strokeColor: UIColor, lineWidth: CGFloat = 1) {
        let frame = base.frame
        base.backgroundColor = .clear
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DashedTopLine"
        shapeLayer.bounds = base.bounds
        shapeLayer.position = CGPoint(x: frame.width / 2, y: frame.height * 1.5)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6, 4]
        
        let path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        shapeLayer.path = path
        
        base.layer.addSublayer(shapeLayer)
    }
    
    func startGlowing(color: UIColor, radius: CGFloat = 1) {
        base.layer.masksToBounds = false
        base.layer.shadowColor = color.cgColor
        base.layer.shadowOpacity = 1
        base.layer.shadowOffset = CGSize(width: -1, height: 1)
        base.layer.shadowRadius = radius
        
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.shadowOpacity))
        animation.duration = 1
        animation.fromValue = base.layer.shadowOpacity
        animation.toValue = 0
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = .greatestFiniteMagnitude
        base.layer.add(animation, forKey: "animateOpacity")
        
    }
    
    func isVisible(_ isVisible: Bool) {
        base.isHidden = !isVisible
        base.translatesAutoresizingMaskIntoConstraints = isVisible
        if isVisible { //if visible we remove the hight constraint
            if let constraint = (base.constraints.filter{$0.firstAttribute == .height}.first){
                base.removeConstraint(constraint)
            }
        } else { //if not visible we add a constraint to force the view to have a hight set to 0
            let height = NSLayoutConstraint(item: base, attribute: .height, relatedBy: .equal , toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 0)
            base.addConstraint(height)
        }
        base.layoutIfNeeded()
    }
    
    func constraintedPadding(horizontal: CGFloat? = nil, vertical: CGFloat? = nil) {
        if let constant = horizontal {
            base.aa.findConstraint(.leading)?.constant = constant
            base.aa.findConstraint(.trailing)?.constant = constant
        }
        if let constant = vertical {
            base.aa.findConstraint(.top)?.constant = constant
            base.aa.findConstraint(.bottom)?.constant = constant
        }
    }
    
    @available(iOS 9.0, *)
    func addConstrainedSubview(_ subview: UIView) {
        base.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: base.topAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: base.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: base.trailingAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: base.bottomAnchor).isActive = true
    }
    
    func addAndFitSubview(_ subview: UIView, insets: UIEdgeInsets = .zero) {
        base.addSubview(subview)
        subview.aa.fitInSuperview(with: insets)
    }
    
    func fitInSuperview(with insets: UIEdgeInsets = .zero) {
        guard let superview = base.superview else {
            assertionFailure("\(AA_TAG) fitInSuperview was called but view was not in a view hierarchy.")
            return
        }
        
        let applyInset: (NSLayoutConstraint.Attribute, UIEdgeInsets) -> CGFloat = {
            switch $0 {
            case .top: return $1.top
            case .bottom: return -$1.bottom
            case .left: return $1.left
            case .right: return -$1.right
            default:
                return 0
            }
        }
        
        base.translatesAutoresizingMaskIntoConstraints = false
        
        let attributes = [NSLayoutConstraint.Attribute.top, .left, .right, .bottom]
        superview.addConstraints(attributes.map {
            return NSLayoutConstraint(item: base,
                                      attribute: $0,
                                      relatedBy: .equal,
                                      toItem: superview,
                                      attribute: $0,
                                      multiplier: 1,
                                      constant: applyInset($0, insets))
        })
    }
    
    func setFontSize(_ size: CGFloat) {
        DispatchQueue.main.async {
            if let self = self.base as? UILabel {
                self.font = self.font.withSize(size)
            }
            else if let self = self.base as? UIButton {
                self.titleLabel?.font = self.titleLabel?.font.withSize(size)
            }
        }
    }
    
    @discardableResult
    func insertLine( start: CGPoint, end: CGPoint, color: UIColor) -> CAShapeLayer {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = color.cgColor
        line.lineWidth = 0.3
        line.lineJoin = .round
        base.layer.insertSublayer(line, at: 0)
        return line
    }
    
    @discardableResult
    func addTopBorderWithColor(color: UIColor, height: CGFloat = 1,
                               paddingX: CGFloat = 0, paddingY: CGFloat = 0) -> CALayer {
        let border = CALayer()
        border.name = "AATopBorder"
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: paddingX, y: paddingY, width: base.frame.size.width, height: height)
        base.layer.addSublayer(border)
        return border
    }
    
    @discardableResult
    func addRightBorderWithColor(color: UIColor, width: CGFloat = 1,
                                 paddingX: CGFloat = 0, paddingY: CGFloat = 0) -> CALayer {
        let border = CALayer()
        border.name = "AARightBorder"
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: (base.frame.size.width - width) + paddingX, y: paddingY, width: width, height: base.frame.size.height)
        base.layer.addSublayer(border)
        return border
    }
    
    @discardableResult
    func addBottomBorderWithColor(color: UIColor, height: CGFloat = 1,
                                  paddingX: CGFloat = 0, paddingY: CGFloat = 0) -> CALayer {
        let border = CALayer()
        border.name = "AABottomBorder"
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: paddingX, y: (base.frame.size.height - height) + paddingY, width: base.frame.size.width, height: height)
        base.layer.addSublayer(border)
        return border
    }
    
    @discardableResult
    func addLeftBorderWithColor(color: UIColor, width: CGFloat = 1,
                                paddingX: CGFloat = 0, paddingY: CGFloat = 0) -> CALayer {
        let border = CALayer()
        border.name = "AALeftBorder"
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: paddingX, y: paddingY, width: width, height: base.frame.size.height)
        base.layer.addSublayer(border)
        return border
    }
    
    @discardableResult
    func addBorderView(to edges: UIRectEdge, color: UIColor, thickness: CGFloat = 1, paddingX: CGFloat = 0, paddingY: CGFloat = 0) -> [UIView] {
        
        var borders = [UIView]()
        let metricDict = ["paddingX": paddingX, "paddingY": paddingY, "thickness": thickness]
        
        func border() -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            base.addSubview(top)
            base.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(paddingY)-[top(==thickness)]",
                                               options: [],
                                               metrics: metricDict,
                                               views: ["top": top]))
            base.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(paddingX)-[top]-(paddingX)-|",
                                               options: [],
                                               metrics: metricDict,
                                               views: ["top": top]))
            borders.append(top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            base.addSubview(left)
            base.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(paddingX)-[left(==thickness)]",
                                               options: [],
                                               metrics: metricDict,
                                               views: ["left": left]))
            base.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(paddingY)-[left]-(paddingY)-|",
                                               options: [],
                                               metrics: metricDict,
                                               views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            base.addSubview(right)
            base.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(paddingX)-|",
                                               options: [],
                                               metrics: metricDict,
                                               views: ["right": right]))
            base.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(paddingY)-[right]-(paddingY)-|",
                                               options: [],
                                               metrics: metricDict,
                                               views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            base.addSubview(bottom)
            base.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(paddingY)-|",
                                               options: [],
                                               metrics: metricDict,
                                               views: ["bottom": bottom]))
            base.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(paddingX)-[bottom]-(paddingX)-|",
                                               options: [],
                                               metrics: metricDict,
                                               views: ["bottom": bottom]))
            borders.append(bottom)
        }
        
        return borders
        
    }
    
    @available(iOS 9.0, *)
    func setGradient(_ model: AAGradientModel) {
        removeGradient()
        let gradientView = AAGradientView(model)
        addAndFitSubview(gradientView)
        base.sendSubviewToBack(gradientView)
        gradientView.isUserInteractionEnabled = false
    }
    
    @available(iOS 9.0, *)
    func removeGradient()
    { findLayer("AAGradientView")?.removeFromSuperlayer() }
    
    func findLayer(_ identifier: String) -> CALayer?
    { base.layer.sublayers?.first(where: { $0.name == identifier }) }
    
    func visibilty(_ flag: Bool)
    { UIView.animate(withDuration: 0.2) { self.base.isHidden = !flag } }
    
    func removeSubViews()
    { base.subviews.forEach {$0.removeFromSuperview()} }
    
    func findViews<T: UIView>(subclassOf: T.Type) -> [T]
    { recursiveSubviews.compactMap { $0 as? T } }
    
    var recursiveSubviews: [UIView]
    { base.subviews + base.subviews.flatMap { $0.aa.recursiveSubviews } }
    
    func endEditingOnTouch()
    { onTap { self.base.superview?.endEditing(true) }.cancelsTouchesInView = true }
    
    func findConstraint(_ attr: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        base.constraints.first(where: {
                                ($0.firstAttribute == attr && $0.firstItem === base) ||
                                ($0.secondAttribute == attr && $0.secondItem === base) })
    }
    
    func insertDottedLine(start: CGPoint, end: CGPoint, color: UIColor) {
        let lineDashPattern: [NSNumber]?  = [3, 3]
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 0.3
        shapeLayer.lineDashPattern = lineDashPattern
        let path = CGMutablePath()
        path.addLines(between: [start, end])
        shapeLayer.path = path
        base.layer.addSublayer(shapeLayer)
    }
    
    func addDashedBorder(strokeColor: UIColor, lineWidth: CGFloat) {
        base.layoutIfNeeded()
        let strokeColor = strokeColor.cgColor
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = base.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [5,5]
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shapeRect.width, height: shapeRect.height), cornerRadius: base.layer.cornerRadius).cgPath
        base.layer.addSublayer(shapeLayer)
    }
    
    @discardableResult
    func onTap(_ closure: @escaping ()-> ()) -> UITapGestureRecognizer {
        let gestureRecognizer = BindableGestureRecognizer(closure)
        gestureRecognizer.numberOfTapsRequired = 1
        base.isUserInteractionEnabled = true
        base.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    func roundCorners(topLeft : Bool, topRight : Bool, bottomLeft : Bool, bottomRight: Bool, strokeColor : UIColor?, lineWidth : CGFloat, radius : CGFloat) -> Void {
        
        if #available(iOS 11.0, *) {
            var corner  = CACornerMask()
            if topLeft { corner = corner.union(.layerMinXMinYCorner) }
            if topRight { corner = corner.union(.layerMaxXMinYCorner) }
            if bottomLeft { corner = corner.union(.layerMinXMaxYCorner) }
            if bottomRight { corner = corner.union(.layerMaxXMaxYCorner) }
            base.layer.cornerRadius = radius
            base.layer.maskedCorners = corner
        }
        else{
            var corner  = UIRectCorner()
            if topLeft { corner = corner.union(.topLeft) }
            if topRight { corner = corner.union(.topRight) }
            if bottomLeft { corner = corner.union(.bottomLeft) }
            if bottomRight { corner = corner.union(.bottomRight) }
            let bounds = base.bounds
            let maskPath1 = UIBezierPath(roundedRect: bounds,
                                         byRoundingCorners:corner,
                                         cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer1 = CAShapeLayer()
            maskLayer1.frame = bounds
            maskLayer1.path = maskPath1.cgPath
            base.layer.mask = maskLayer1
        }
    }
    
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.layer.frame.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        base.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    var statusBarSize: CGSize {
        let statusBarFrame: CGSize
        if #available(iOS 13.0, *) {
            statusBarFrame = base.window?.windowScene?.statusBarManager?.statusBarFrame.size ?? .zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame.size
        }
        return statusBarFrame
    }
    
    var statusBarStyle: UIStatusBarStyle? {
        let style: UIStatusBarStyle?
        if #available(iOS 13.0, *) {
            style = base.window?.windowScene?.statusBarManager?.statusBarStyle
        } else {
            style = UIApplication.shared.statusBarStyle
        }
        return style
    }
    
    
    // Constraints
    
    func constraint(view1: UIView, view2: UIView, attr1: NSLayoutConstraint.Attribute, attr2: NSLayoutConstraint.Attribute, constant: CGFloat = 0) {
        base.addConstraint(NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: .equal, toItem: view2, attribute: attr2, multiplier: 1, constant: constant))
    }
    
    func constantConstaint(attr: NSLayoutConstraint.Attribute, constant: CGFloat) {
        base.addConstraint(NSLayoutConstraint(item: base, attribute: attr, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constant))
    }
    
    func bindConstraints(_ view1: UIView, view2: UIView, bindAttrs: [NSLayoutConstraint.Attribute]) {
        let bindConstraints = bindAttrs.compactMap({
            NSLayoutConstraint(item: view1, attribute: $0, relatedBy: .equal, toItem: view2, attribute: $0, multiplier: 1.0, constant: 0)
        })
        base.addConstraints(bindConstraints)
    }
    
    func bindConstraints(_ withView: UIView, bindAttrs: [NSLayoutConstraint.Attribute]) {
        let bindConstraints = bindAttrs.compactMap({
            NSLayoutConstraint(item: withView, attribute: $0, relatedBy: .equal, toItem: base, attribute: $0, multiplier: 1.0, constant: 0)
        })
        base.addConstraints(bindConstraints)
    }
    
    func layoutItems(bindAttrs: [NSLayoutConstraint.Attribute], preAttr: NSLayoutConstraint.Attribute, nextAttr: NSLayoutConstraint.Attribute, equalAttr: NSLayoutConstraint.Attribute) {
        let items = base.subviews
        let constraints = items.enumerated().flatMap { (index, label) -> [NSLayoutConstraint] in
            var constraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
            
            /// Constraints to bind the views
            let bindConstraints = bindAttrs.compactMap({ (attr) -> NSLayoutConstraint in
                return NSLayoutConstraint(item: label, attribute: attr, relatedBy: .equal, toItem: base, attribute: attr, multiplier: 1.0, constant: 0)
            })
            
            constraints.append(contentsOf: bindConstraints)
            
            /// Constraint after the view
            var nextConstraint : NSLayoutConstraint {
                
                guard index != items.count - 1 else {
                    return NSLayoutConstraint(item: label, attribute: nextAttr, relatedBy: .equal, toItem: base, attribute: nextAttr, multiplier: 1.0, constant: 0)
                }
                let nextItem = items[index+1]
                return NSLayoutConstraint(item: label, attribute: nextAttr, relatedBy: .equal, toItem: nextItem, attribute: preAttr, multiplier: 1.0, constant: 0)
            }
            
            constraints.append(nextConstraint)
            
            /// Constraint before the view
            var preConstraint : NSLayoutConstraint {
                
                guard index != 0 else {
                    
                    return NSLayoutConstraint(item: label, attribute: preAttr, relatedBy: .equal, toItem: base, attribute: preAttr, multiplier: 1.0, constant: 0)
                }
                
                /// Constraint equal the first view
                let equalConstraint = NSLayoutConstraint(item: label, attribute: equalAttr, relatedBy: .equal, toItem: items.first!, attribute: equalAttr, multiplier: 1.0, constant: 0)
                
                constraints.append(equalConstraint)
                
                let prevItem = items[index-1]
                return NSLayoutConstraint(item: label, attribute: preAttr, relatedBy: .equal, toItem: prevItem, attribute: nextAttr, multiplier: 1.0, constant: 0)
                
            }
            
            constraints.append(preConstraint)
            
            return constraints
        }
        
        base.addConstraints(constraints)
    }
    
    //
    
    func addMaskView(maskColor: UIColor, duration: TimeInterval = 0.2, onHide: (() -> ())?) -> ((Bool) -> ()) {
        let maskView = UIView()
        maskView.frame = base.bounds
        maskView.backgroundColor = maskColor
        
        func hide() {
            maskView.alpha = 1
            
            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: .curveEaseOut,
                           animations: { () -> Void in
                            maskView.alpha = 0
                           }) { (result: Bool) -> Void in
                onHide?()
                maskView.removeFromSuperview()
            }
        }
        
        func show() {
            maskView.alpha = 0
            base.addSubview(maskView)
            maskView.aa.onTap { hide() }
            UIView.animate(withDuration: duration*2,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: .curveEaseOut,
                           animations: { () -> Void in
                            maskView.alpha = 1
                           }, completion: nil)
        }
        
        func toggle(_ flag: Bool) {
            if flag { show() }
            else { hide() }
        }
        
        return toggle(_:)
        
    }
}
