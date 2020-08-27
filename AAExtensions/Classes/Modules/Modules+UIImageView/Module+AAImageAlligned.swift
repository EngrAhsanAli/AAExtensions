//
//  Module+AAImageAlligned.swift
//  AACameraView
//
//  Created by Muhammad Ahsan Ali on 2020/08/21.
//

import Foundation

public struct AAImageAllignedMask: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    
    /// The option to align the content to the center.
    public static let center = AAImageAllignedMask([])
    /// The option to align the content to the left.
    public static let left = AAImageAllignedMask(rawValue: 1 << 0)
    /// The option to align the content to the right.
    public static let right = AAImageAllignedMask(rawValue: 1 << 1)
    /// The option to align the content to the top.
    public static let top = AAImageAllignedMask(rawValue: 1 << 2)
    /// The option to align the content to the bottom.
    public static let bottom = AAImageAllignedMask(rawValue: 1 << 3)
    /// The option to align the content to the top left.
    public static let topLeft: AAImageAllignedMask = [top, left]
    /// The option to align the content to the top right.
    public static let topRight: AAImageAllignedMask = [top, right]
    /// The option to align the content to the bottom left.
    public static let bottomLeft: AAImageAllignedMask = [bottom, left]
    /// The option to align the content to the bottom right.
    public static let bottomRight: AAImageAllignedMask = [bottom, right]
}

@IBDesignable
open class AAImageAlligned: UIImageView {
    
    /**
     The technique to use for aligning the image.
     
     Changes to this property can be animated.
     */
    open var alignment: AAImageAllignedMask = .center {
        didSet {
            guard alignment != oldValue else { return }
            updateLayout()
        }
    }
    
    open override var image: UIImage? {
        set {
            realImageView?.image = newValue
            setNeedsLayout()
        }
        get {
            return realImageView?.image
        }
    }
    
    open override var highlightedImage: UIImage? {
        set {
            realImageView?.highlightedImage = newValue
            setNeedsLayout()
        }
        get {
            return realImageView?.highlightedImage
        }
    }
    
    /**
     The option to align the content to the top.
     
     It is available in Interface Builder and should not be set programmatically. Use `alignment` property if you want to set alignment outside Interface Builder.
     */
    @IBInspectable open var alignTop: Bool {
        set {
            setInspectableProperty(newValue, alignment: .top)
        }
        get {
            return getInspectableProperty(.top)
        }
    }
    
    /**
     The option to align the content to the left.
     
     It is available in Interface Builder and should not be set programmatically. Use `alignment` property if you want to set alignment outside Interface Builder.
     */
    @IBInspectable open var alignLeft: Bool {
        set {
            setInspectableProperty(newValue, alignment: .left)
        }
        get {
            return getInspectableProperty(.left)
        }
    }
    
    /**
     The option to align the content to the right.
     
     It is available in Interface Builder and should not be set programmatically. Use `alignment` property if you want to set alignment outside Interface Builder.
     */
    @IBInspectable open var alignRight: Bool {
        set {
            setInspectableProperty(newValue, alignment: .right)
        }
        get {
            return getInspectableProperty(.right)
        }
    }
    
    /**
     The option to align the content to the bottom.
     
     It is available in Interface Builder and should not be set programmatically. Use `alignment` property if you want to set alignment outside Interface Builder.
     */
    @IBInspectable open var alignBottom: Bool {
        set {
            setInspectableProperty(newValue, alignment: .bottom)
        }
        get {
            return getInspectableProperty(.bottom)
        }
    }
    
    open override var isHighlighted: Bool {
        set {
            super.isHighlighted = newValue
            layer.contents = nil
        }
        get {
            return super.isHighlighted
        }
    }
    
    /**
     The inner image view.
     
     It should be used only when necessary.
     Accessible to keep compatibility with the original `UIImageViewAligned`.
     */
    public private(set) var realImageView: UIImageView?
    
    private var realContentSize: CGSize {
        var size = bounds.size
        
        guard let image = image else { return size }
        
        let scaleX = size.width / image.size.width
        let scaleY = size.height / image.size.height
        
        switch contentMode {
        case .scaleAspectFill:
            let scale = max(scaleX, scaleY)
            size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
            
        case .scaleAspectFit:
            let scale = min(scaleX, scaleY)
            size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
            
        case .scaleToFill:
            size = CGSize(width: image.size.width * scaleX, height: image.size.height * scaleY)
            
        default:
            size = image.size
        }
        
        return size
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        setup(image: image)
    }
    
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        setup(image: image, highlightedImage: highlightedImage)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        updateLayout()
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layer.contents = nil
    }
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        layer.contents = nil
        if #available(iOS 11, *) {
            let currentImage = realImageView?.image
            image = UIImage()
            realImageView?.image = currentImage
        }
    }
    
    private func setup(image: UIImage? = nil, highlightedImage: UIImage? = nil) {
        realImageView = UIImageView(image: image ?? super.image, highlightedImage: highlightedImage ?? super.highlightedImage)
        realImageView?.frame = bounds
        realImageView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        realImageView?.contentMode = contentMode
        addSubview(realImageView!)
    }
    
    private func updateLayout() {
        let realSize = realContentSize
        var realFrame = CGRect(origin: CGPoint(x: (bounds.size.width - realSize.width) / 2.0,
                                               y: (bounds.size.height - realSize.height) / 2.0),
                               size: realSize)
        
        if alignment.contains(.left) {
            realFrame.origin.x = 0.0
        } else if alignment.contains(.right) {
            realFrame.origin.x = bounds.maxX - realFrame.size.width
        }
        
        if alignment.contains(.top) {
            realFrame.origin.y = 0.0
        } else if alignment.contains(.bottom) {
            realFrame.origin.y = bounds.maxY - realFrame.size.height
        }
        
        realImageView?.frame = realFrame.integral
        
        // Make sure we clear the contents of this container layer, since it refreshes from the image property once in a while.
        layer.contents = nil
        if #available(iOS 11, *) {
            super.image = UIImage()
        }
    }
    
    private func setInspectableProperty(_ newValue: Bool, alignment: AAImageAllignedMask) {
        if newValue {
            self.alignment.insert(alignment)
        } else {
            self.alignment.remove(alignment)
        }
    }
    
    private func getInspectableProperty(_ alignment: AAImageAllignedMask) -> Bool {
        return self.alignment.contains(alignment)
    }
}
