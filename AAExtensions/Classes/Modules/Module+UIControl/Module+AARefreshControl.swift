//
//  Module+AARefreshControl.swift
//  AAExtensions
//
//  Created by Ahsan Ali on 31/05/2019.
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

/// AARefreshControl for UITableView and UICollectionView
open class AARefreshControl: UIControl {
    
    var kTotalViewHeight   : CGFloat = 400
    var kOpenedViewHeight  : CGFloat = 44
    var kMinTopPadding     : CGFloat = 9
    var kMaxTopPadding     : CGFloat = 5
    var kMinTopRadius      : CGFloat = 12.5
    var kMaxTopRadius      : CGFloat = 16
    var kMinBottomRadius   : CGFloat = 3
    var kMaxBottomRadius   : CGFloat = 16
    var kMinBottomPadding  : CGFloat = 4
    var kMaxBottomPadding  : CGFloat = 6
    var kMinArrowSize      : CGFloat = 2
    var kMaxArrowSize      : CGFloat = 3
    var kMinArrowRadius    : CGFloat = 5
    var kMaxArrowRadius    : CGFloat = 7
    var kMaxDistance       : CGFloat = 53
    
    var activity: UIView!
    fileprivate var shapeLayer: CAShapeLayer!
    fileprivate var arrowLayer: CAShapeLayer!
    fileprivate var highlightLayer: CAShapeLayer!
    fileprivate var scrollView: UIScrollView!
    fileprivate var originalContentInset: UIEdgeInsets = .zero
    
    private(set) var refreshing = false
    private(set) var canRefresh = false
    fileprivate var ignoreInset = false
    fileprivate var ignoreOffset = false
    fileprivate var didSetInset = false
    fileprivate var hasSectionHeaders = false
    fileprivate var lastOffset: CGFloat = 0.0
    
    var activityIndicatorViewStyle: UIActivityIndicatorView.Style {
        get {
            if let a = activity as? UIActivityIndicatorView {
                return a.style
            }
            return .gray
        }
        set {
            if let a = activity as? UIActivityIndicatorView {
                a.style = newValue
            }
        }
    }
    
    var activityIndicatorViewColor: UIColor? {
        get {
            if let a = activity as? UIActivityIndicatorView {
                return a.color
            }
            return nil
        }
        set {
            if let a = activity as? UIActivityIndicatorView {
                a.color = newValue
            }
        }
    }

    fileprivate func lerp(a: CGFloat, b: CGFloat, p: CGFloat) -> CGFloat {
        return a + (b - a) * p;
    }
    
    public init(scrollView: UIScrollView, activityView: UIView? = nil) {
        super.init(frame: CGRect(x: 0, y: -(kTotalViewHeight + scrollView.contentInset.top),
                                 width: scrollView.frame.size.width, height: kTotalViewHeight))
        self.scrollView = scrollView
        originalContentInset = scrollView.contentInset
        autoresizingMask = .flexibleWidth
        scrollView.addSubview(self)
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        scrollView.addObserver(self, forKeyPath: "contentInset", options: .new, context: nil)
        activity = activityView != nil ? activityView : UIActivityIndicatorView(style: .gray)
        activity.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        activity.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        activity.alpha = 0
        if let a = activity as? UIActivityIndicatorView {
            a.startAnimating()
        }
        addSubview(activity)
        
        refreshing = false
        canRefresh = true
        ignoreInset = false
        ignoreOffset = false
        didSetInset = false
        hasSectionHeaders = false
        tintColor = UIColor(red:155.0 / 255.0, green: 162.0 / 255.0, blue: 172.0 / 255.0, alpha: 1.0)
        
        shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = tintColor.cgColor
        shapeLayer.strokeColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: 1)
        shapeLayer.shadowOpacity = 0.4
        shapeLayer.shadowRadius = 0.5
        layer.addSublayer(shapeLayer)
        
        arrowLayer = CAShapeLayer()
        arrowLayer.strokeColor =  UIColor.darkGray.withAlphaComponent(0.5).cgColor
        arrowLayer.lineWidth = 0.5
        arrowLayer.fillColor = UIColor.white.cgColor
        shapeLayer.addSublayer(arrowLayer)
        
        highlightLayer = CAShapeLayer()
        highlightLayer.fillColor = UIColor.white.withAlphaComponent(0.2).cgColor
        shapeLayer.addSublayer(highlightLayer)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("AAExtensions:- init(coder:) has not been implemented")
    }
    
    deinit {
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
        scrollView.removeObserver(self, forKeyPath: "contentInset")
        scrollView = nil
    }
    
    override open var isEnabled: Bool {
        didSet {
            if shapeLayer != nil {
                shapeLayer.isHidden = !isEnabled
            }
        }
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil {
            scrollView.removeObserver(self, forKeyPath: "contentOffset")
            scrollView.removeObserver(self, forKeyPath: "contentInset")
            scrollView = nil
        }
    }
    
    override open var tintColor: UIColor! {
        didSet {
            if shapeLayer != nil {
                shapeLayer.fillColor = tintColor.cgColor
            }
        }
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentInset" {
            if !ignoreInset {
                if let value = change?[.newKey] as? UIEdgeInsets {
                    originalContentInset = value
                }
                frame = CGRect(x: 0, y: -(kTotalViewHeight + self.scrollView.contentInset.top),
                               width: self.scrollView.frame.size.width, height: kTotalViewHeight)
            }
            return
        }
        
        if !isEnabled || ignoreOffset {
            return
        }
        
        var offset: CGFloat = 0
        if let value = change?[.newKey] as? CGPoint {
            offset = value.y + originalContentInset.top
        }
        
        if refreshing {
            if offset != 0 {
                // Keep thing pinned at the top
                
                CATransaction.begin()
                CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                shapeLayer.position = CGPoint(x: 0, y: kMaxDistance + offset + kOpenedViewHeight)
                CATransaction.commit()
                
                activity.center = CGPoint(x: floor(frame.size.width / 2.0),
                                          y: min(offset + frame.size.height + floor(kOpenedViewHeight / 2.0),
                                                 frame.size.height - kOpenedViewHeight / 2.0))
                ignoreInset = true
                ignoreOffset = true
                
                if offset < 0 {
                    // Set the inset depending on the situation
                    if offset >= -kOpenedViewHeight {
                        if !scrollView.isDragging {
                            if !didSetInset {
                                didSetInset = true
                                hasSectionHeaders = false
                                if let tableView = scrollView as? UITableView {
                                    for i in 0..<tableView.numberOfSections{
                                        if tableView.rectForHeader(inSection: i).size.height != 0 {
                                            hasSectionHeaders = true
                                            break
                                        }
                                    }
                                }
                            }
                            
                            if hasSectionHeaders {
                                scrollView.contentInset = UIEdgeInsets(
                                    top: min(-offset, kOpenedViewHeight) + originalContentInset.top,
                                    left: originalContentInset.left,
                                    bottom: originalContentInset.bottom,
                                    right: originalContentInset.right)
                            }else {
                                scrollView.contentInset = UIEdgeInsets(
                                    top: kOpenedViewHeight + originalContentInset.top,
                                    left: originalContentInset.left,
                                    bottom: originalContentInset.bottom,
                                    right: originalContentInset.right)
                            }
                        }else if didSetInset && hasSectionHeaders {
                            scrollView.contentInset = UIEdgeInsets(
                                top: -offset + self.originalContentInset.top,
                                left: originalContentInset.left,
                                bottom: originalContentInset.bottom,
                                right: originalContentInset.right)
                        }
                    }
                }else if hasSectionHeaders {
                    scrollView.contentInset = originalContentInset
                }
                ignoreInset = false
                ignoreOffset = false
            }
            return
        }else {
            // Check if we can trigger a new refresh and if we can draw the control
            var dontDraw = false
            if !canRefresh {
                if offset >= 0 {
                    // We can refresh again after the control is scrolled out of view
                    canRefresh = true
                    didSetInset = false
                }else {
                    dontDraw = true
                }
            }else {
                if offset >= 0 {
                    // Don't draw if the control is not visible
                    dontDraw = true
                }
            }
            if offset > 0 && (lastOffset > offset) && !scrollView.isTracking {
                // If we are scrolling too fast, don't draw, and don't trigger unless the scrollView bounced back
                canRefresh = false
                dontDraw = true
            }
            if dontDraw {
                shapeLayer.path = nil
                shapeLayer.shadowPath = nil
                arrowLayer.path = nil
                highlightLayer.path = nil
                lastOffset = offset
                return
            }
        }
        
        lastOffset = offset
        
        var triggered = false
        
        let path = CGMutablePath()
        
        //Calculate some useful points and values
        let verticalShift = max(0, -((kMaxTopRadius + kMaxBottomRadius + kMaxTopPadding + kMaxBottomPadding) + offset))
        let distance = min(kMaxDistance, abs(verticalShift))
        let percentage = 1 - (distance / kMaxDistance)
        
        let currentTopPadding = lerp(a: kMinTopPadding, b: kMaxTopPadding, p: percentage)
        let currentTopRadius = lerp(a: kMinTopRadius, b: kMaxTopRadius, p: percentage)
        let currentBottomRadius = lerp(a: kMinBottomRadius, b: kMaxBottomRadius, p: percentage)
        let currentBottomPadding =  lerp(a: kMinBottomPadding, b: kMaxBottomPadding, p: percentage)
        
        var bottomOrigin = CGPoint(x: floor(self.bounds.size.width / 2), y: self.bounds.size.height - currentBottomPadding - currentBottomRadius)
        var topOrigin = CGPoint.zero
        if distance == 0 {
            topOrigin = CGPoint(x: floor(self.bounds.size.width / 2), y: bottomOrigin.y)
        }else {
            topOrigin = CGPoint(x: floor(self.bounds.size.width / 2), y: self.bounds.size.height + offset + currentTopPadding + currentTopRadius)
            if percentage == 0 {
                bottomOrigin.y -= (abs(verticalShift) - kMaxDistance)
                triggered = true
            }
        }
        
        //Top semicircle
        path.addArc(center: topOrigin, radius: currentTopRadius, startAngle: 0, endAngle: .pi, clockwise: true)
        
        //Left curve
        let leftCp1 = CGPoint(
            x: lerp(a: (topOrigin.x - currentTopRadius), b: (bottomOrigin.x - currentBottomRadius), p: 0.1),
            y: lerp(a: topOrigin.y, b: bottomOrigin.y, p: 0.2))
        let leftCp2 = CGPoint(
            x: lerp(a: (topOrigin.x - currentTopRadius), b: (bottomOrigin.x - currentBottomRadius), p: 0.9),
            y: lerp(a: topOrigin.y, b: bottomOrigin.y, p: 0.2))
        let leftDestination = CGPoint(x: bottomOrigin.x - currentBottomRadius, y: bottomOrigin.y)
        
        path.addCurve(to: leftDestination,
                      control1: leftCp1,
                      control2: leftCp2)
        //Bottom semicircle
        path.addArc(center: bottomOrigin, radius: currentBottomRadius, startAngle: .pi, endAngle: 0, clockwise: true)
        
        //Right curve
        let rightCp2 = CGPoint(
            x: lerp(a: (topOrigin.x + currentTopRadius), b: (bottomOrigin.x + currentBottomRadius), p: 0.1),
            y: lerp(a: topOrigin.y, b: bottomOrigin.y, p: 0.2))
        let rightCp1 = CGPoint(
            x: lerp(a: (topOrigin.x + currentTopRadius), b: (bottomOrigin.x + currentBottomRadius), p: 0.9),
            y: lerp(a: topOrigin.y, b: bottomOrigin.y, p: 0.2))
        let rightDestination = CGPoint(x: topOrigin.x + currentTopRadius, y: topOrigin.y)
        
        path.addCurve(to: rightDestination,
                      control1: rightCp1,
                      control2: rightCp2)
        path.closeSubpath()
        
        if !triggered {
            // Set paths
            
            shapeLayer.path = path
            shapeLayer.shadowPath = path
            
            // Add the arrow shape
            
            let currentArrowSize = lerp(a: kMinArrowSize, b: kMaxArrowSize, p: percentage)
            let currentArrowRadius = lerp(a: kMinArrowRadius, b: kMaxArrowRadius, p: percentage)
            let arrowBigRadius = currentArrowRadius + (currentArrowSize / 2)
            let arrowSmallRadius = currentArrowRadius - (currentArrowSize / 2)
            let arrowPath = CGMutablePath()
            
            arrowPath.addArc(center: topOrigin, radius: arrowBigRadius, startAngle: 0, endAngle: CGFloat(3 * M_PI_2), clockwise: false)
            arrowPath.addLine(to: CGPoint(x: topOrigin.x, y: topOrigin.y - arrowBigRadius - currentArrowSize))
            arrowPath.addLine(to: CGPoint(x: topOrigin.x + (2 * currentArrowSize), y: topOrigin.y - arrowBigRadius + (currentArrowSize / 2)))
            arrowPath.addLine(to: CGPoint(x: topOrigin.x, y: topOrigin.y - arrowBigRadius + (2 * currentArrowSize)))
            arrowPath.addLine(to: CGPoint(x: topOrigin.x, y: topOrigin.y - arrowBigRadius + currentArrowSize))
            arrowPath.addArc(center: topOrigin, radius: arrowSmallRadius, startAngle: CGFloat(3 * M_PI_2), endAngle: 0, clockwise: true)
            arrowPath.closeSubpath()
            arrowLayer.path = arrowPath
            arrowLayer.fillRule = CAShapeLayerFillRule.evenOdd
            
            // Add the highlight shape
            
            let highlightPath = CGMutablePath()
            highlightPath.addArc(center: topOrigin, radius: currentTopRadius, startAngle: 0, endAngle: .pi, clockwise: true)
            highlightPath.addArc(center: CGPoint(x: topOrigin.x, y: topOrigin.y + 1.25), radius: currentTopRadius, startAngle: .pi, endAngle: 0, clockwise: false)
            highlightLayer.path = highlightPath
            highlightLayer.fillRule = CAShapeLayerFillRule.nonZero
        }else {
            // Start the shape disappearance animation
            
            let radius = lerp(a: kMinBottomRadius, b: kMaxBottomRadius, p: 0.2)
            let pathMorph = CABasicAnimation(keyPath: "path")
            pathMorph.duration = 0.15
            pathMorph.fillMode = CAMediaTimingFillMode.forwards
            pathMorph.isRemovedOnCompletion = false
            
            let toPath = CGMutablePath()
            toPath.addArc(center: topOrigin, radius: radius, startAngle: 0, endAngle: .pi, clockwise: true)
            toPath.addCurve(to: CGPoint(x:  topOrigin.x - radius, y: topOrigin.y),
                            control1: CGPoint(x:  topOrigin.x - radius, y: topOrigin.y),
                            control2: CGPoint(x:  topOrigin.x - radius, y: topOrigin.y))
            toPath.addArc(center: topOrigin, radius: radius, startAngle: .pi, endAngle: 0, clockwise: true)
            toPath.addCurve(to: CGPoint(x:  topOrigin.x + radius, y: topOrigin.y),
                            control1: CGPoint(x:  topOrigin.x + radius, y: topOrigin.y),
                            control2: CGPoint(x:  topOrigin.x + radius, y: topOrigin.y))
            toPath.closeSubpath()
            pathMorph.toValue = toPath
            shapeLayer.add(pathMorph, forKey: nil)
            
            let shadowPathMorph = CABasicAnimation(keyPath: "shadowPath")
            shadowPathMorph.duration = 0.15
            shadowPathMorph.fillMode = CAMediaTimingFillMode.forwards
            shadowPathMorph.isRemovedOnCompletion = false
            shadowPathMorph.toValue = toPath
            shapeLayer.add(shadowPathMorph, forKey: nil)
            
            let shapeAlphaAnimation = CABasicAnimation(keyPath: "opacity")
            shapeAlphaAnimation.duration = 0.1
            shapeAlphaAnimation.beginTime = CACurrentMediaTime() + 0.1
            shapeAlphaAnimation.toValue = NSNumber(value: 0)
            shapeAlphaAnimation.fillMode = CAMediaTimingFillMode.forwards
            shapeAlphaAnimation.isRemovedOnCompletion = false
            shapeLayer.add(shapeAlphaAnimation, forKey: nil)
            
            let alphaAnimation = CABasicAnimation(keyPath: "opacity")
            alphaAnimation.duration = 0.1
            alphaAnimation.toValue = NSNumber(value: 0)
            alphaAnimation.fillMode = CAMediaTimingFillMode.forwards
            alphaAnimation.isRemovedOnCompletion = false
            arrowLayer.add(alphaAnimation, forKey: nil)
            highlightLayer.add(alphaAnimation, forKey: nil)
            
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            activity.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
            CATransaction.commit()
            UIView.animate(withDuration: 0.2, delay: 0.15, options: .curveLinear, animations: {
                self.activity.alpha = 1
                self.activity.layer.transform = CATransform3DMakeScale(1, 1, 1)
            }, completion: nil)
            
            refreshing = true
            canRefresh = false
            sendActions(for: .valueChanged)
        }
    }
    
    func beginRefreshing() {
        if !refreshing {
            let alphaAnimation = CABasicAnimation(keyPath: "opacity")
            alphaAnimation.duration = 0.0001
            alphaAnimation.toValue = NSNumber(value: 0)
            alphaAnimation.fillMode = CAMediaTimingFillMode.forwards
            alphaAnimation.isRemovedOnCompletion = false
            shapeLayer.add(alphaAnimation, forKey: nil)
            arrowLayer.add(alphaAnimation, forKey: nil)
            highlightLayer.add(alphaAnimation, forKey: nil)
            
            activity.alpha = 1
            activity.layer.transform = CATransform3DMakeScale(1, 1, 1)
            
            let offset = self.scrollView.contentOffset
            ignoreInset = true
            scrollView.contentInset = UIEdgeInsets(top: kOpenedViewHeight + originalContentInset.top, left: originalContentInset.left, bottom: originalContentInset.bottom, right: originalContentInset.right)
            ignoreInset = false
            scrollView.setContentOffset(offset, animated: false)
            
            refreshing = true
            canRefresh = false
        }
    }
    
    func endRefreshing() {
        if refreshing {
            refreshing = false
            // Create a temporary retain-cycle, so the scrollView won't be released
            // halfway through the end animation.
            // This allows for the refresh control to clean up the observer,
            // in the case the scrollView is released while the animation is running
            
            //__block UIScrollView *blockScrollView = self.scrollView;
            let sv = scrollView
            UIView.animate(withDuration: 0.4, animations: { [weak sv] in
                self.ignoreInset = true
                sv?.contentInset = self.originalContentInset
                self.ignoreInset = false
                self.activity.alpha = 0
                self.activity.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
                }, completion: { [weak sv](finished) in
                    self.shapeLayer.removeAllAnimations()
                    self.shapeLayer.path = nil
                    self.shapeLayer.shadowPath = nil
                    self.shapeLayer.position = .zero
                    self.arrowLayer.removeAllAnimations()
                    self.arrowLayer.path = nil
                    self.highlightLayer.removeAllAnimations()
                    self.highlightLayer.path = nil
                    // We need to use the scrollView somehow in the end block,
                    // or it'll get released in the animation block.
                    self.ignoreInset = true
                    sv?.contentInset = self.originalContentInset
                    self.ignoreInset = false
            })
        }
    }
    
}
