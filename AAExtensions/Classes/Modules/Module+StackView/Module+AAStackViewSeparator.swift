//
//  Module+AAStackViewSeparator.swift
//  AAExtensions
//
//  Created by MacBook Pro on 17/03/2019.
//

@available(iOS 9.0, *)
@IBDesignable class AAStackViewSeparator: UIStackView {
    
    @IBInspectable open var leftSide: UIColor? = nil
    @IBInspectable open var rightSide: UIColor? = nil
    @IBInspectable open var topSide: UIColor? = nil
    @IBInspectable open var bottomSide: UIColor? = nil
    @IBInspectable open var separatorWidth: CGFloat = 0.5
    
    @IBInspectable private var separatorTopPadding: CGFloat = 0 {
        didSet {
            separatorInsets.top = separatorTopPadding
        }
    }
    @IBInspectable private var separatorBottomPadding: CGFloat = 0 {
        didSet {
            separatorInsets.bottom = separatorBottomPadding
        }
    }
    @IBInspectable private var separatorLeftPadding: CGFloat = 0 {
        didSet {
            separatorInsets.left = separatorLeftPadding
        }
    }
    @IBInspectable private var separatorRightPadding: CGFloat = 0 {
        didSet {
            separatorInsets.right = separatorRightPadding
        }
    }

    var separatorInsets: UIEdgeInsets = .zero {
        didSet {
            invalidateSeparators()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateSeparators()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    private func invalidateSeparators() {
        
        arrangedSubviews.forEach { (stackedView) in
            
            if let side = topSide {
                stackedView.aa_addTopBorderWithColor(color: side, width: separatorWidth, paddingX: separatorInsets.top, paddingY: separatorInsets.bottom)
            } else if let side = leftSide {
                stackedView.aa_addLeftBorderWithColor(color: side, width: separatorWidth, paddingX: separatorInsets.left, paddingY: separatorInsets.right)
            } else if let side = rightSide {
                stackedView.aa_addRightBorderWithColor(color: side, width: separatorWidth, paddingX: separatorInsets.right, paddingY: separatorInsets.left)
            } else if let side = bottomSide {
                stackedView.aa_addBottomBorderWithColor(color: side, width: separatorWidth, paddingX: separatorInsets.bottom, paddingY: separatorInsets.top)
            }
            
        }
        
    }
}
