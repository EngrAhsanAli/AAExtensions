//
//  Module+AAImageButton.swift
//  AAExtensions
//
//  Created by Muhammad Ahsan Ali on 2020/05/26.
//

import Foundation

@objc open class AAImageButton: UIButton {
    
    /// Represents horizontal side for the imagePosition attribute
    @objc public enum Side: Int {
        case left, right
    }
    
    /// The spacing between the button image and the button title
    @IBInspectable open var spacing: CGFloat = 0.0 as CGFloat {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    /// The side of the button to display the image on
    @objc open var imagePosition: Side = Side.left {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// IBInspectable accessor for imagePosition
    @objc @IBInspectable open var imageOnRight: Bool {
        get {
            return imagePosition == .right
        }
        set {
            imagePosition = newValue ? .right : .left
        }
    }
    
    // MARK: - Spacing
    
    /**
     Controls enabling adjustments of the edgeInsets to realize the spacing.
     Increment to enable, decrement to disable.
     
     Adjustments are enabled for any value > 0
     
     Should only be used inside intristicContentSize and fooRectForBar methods
     */
    private var enableSpacingAdjustments = 0
    
    override open var contentEdgeInsets: UIEdgeInsets {
        get {
            let adjustment = (enableSpacingAdjustments > 0) ? (spacing/2) : 0
            return super.contentEdgeInsets.adjust(left: adjustment, right: adjustment)
        }
        set(contentEdgeInsets) { super.contentEdgeInsets = contentEdgeInsets }
    }
    
    override open var titleEdgeInsets: UIEdgeInsets {
        get {
            let adjustment = (enableSpacingAdjustments > 0) ? (spacing/2) : 0
            return super.titleEdgeInsets.adjust(left: adjustment, right: -adjustment)
        }
        set(titleEdgeInsets) { super.titleEdgeInsets = titleEdgeInsets }
    }
    
    override open var imageEdgeInsets: UIEdgeInsets {
        get {
            let adjustment = (enableSpacingAdjustments > 0) ? (spacing/2) : 0
            return super.imageEdgeInsets.adjust(left: -adjustment, right: adjustment)
        }
        set(imageEdgeInsets) { super.imageEdgeInsets = imageEdgeInsets }
    }
    
    open override var intrinsicContentSize: CGSize {
        enableSpacingAdjustments += 1
        let contentSize = super.intrinsicContentSize
        enableSpacingAdjustments -= 1
        
        return contentSize
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        enableSpacingAdjustments += 1
        let size = super.sizeThatFits(size)
        enableSpacingAdjustments -= 1
        
        return size
    }
    
    open override func contentRect(forBounds bounds: CGRect) -> CGRect {
        enableSpacingAdjustments += 1
        let contentRect = super.contentRect(forBounds: bounds)
        enableSpacingAdjustments -= 1
        
        return contentRect
    }
    
    
    // MARK: - Image Side
    
    open override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        enableSpacingAdjustments += 1
        var titleRect = super.titleRect(forContentRect: contentRect)
        let imageRect = super.imageRect(forContentRect: contentRect)
        enableSpacingAdjustments -= 1
        
        if imagePosition == .right {
            titleRect.origin.x = imageRect.minX
        }
        
        return titleRect
    }
    
    open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        enableSpacingAdjustments += 1
        let titleRect = super.titleRect(forContentRect: contentRect)
        var imageRect = super.imageRect(forContentRect: contentRect)
        enableSpacingAdjustments -= 1
        
        if imagePosition == .right {
            imageRect.origin.x = titleRect.maxX - imageRect.width
        }
        
        return imageRect
    }
}

fileprivate extension UIEdgeInsets {
    
    /**
     Relatively adjusts the left and right parameters of a given UIEdgeInsets by the given values
     
     - parameter left:  The value to add to the left parameter of the edge inset
     - parameter right: The value to add to the right parameter of the edge inset
     
     - returns: The adjusted edge inset
     */
    func adjust(left: CGFloat, right: CGFloat) -> UIEdgeInsets {
        var edgeInsets = self
        edgeInsets.left += left
        edgeInsets.right += right
        
        return edgeInsets
    }
    
}

public extension AAImageButton {
    
    func choiceButton(_ isSingle: Bool, text: String, normalImage: UIImage, selectedImage: UIImage) {
        
        imagePosition = .left
        spacing = 10
        imageEdgeInsets = .init(top: 5, left: 0, bottom: 5, right: 0)
        
        setImage(normalImage, for: .normal)
        setImage(selectedImage, for: .selected)
        imageView?.contentMode = .scaleAspectFit
        contentHorizontalAlignment = .left
        setTitle(text, for: .normal)
        setTitleColor(.black, for: .normal)
        setImage(normalImage, for: .normal)
        setImage(selectedImage, for: .selected)
        
    }
    
}
