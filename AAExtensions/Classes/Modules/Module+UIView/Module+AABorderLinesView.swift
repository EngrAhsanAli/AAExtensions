//
//  Module+AABorderLinesView.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//


@IBDesignable
public class AABorderLinesView: UIView {
        
    @IBInspectable open var paddingX: CGFloat = 0
    @IBInspectable open var paddingY: CGFloat = 0
    @IBInspectable open var lineWidth: CGFloat = 1
    @IBInspectable open var leftSide: UIColor? = nil
    @IBInspectable open var rightSide: UIColor? = nil
    @IBInspectable open var topSide: UIColor? = nil
    @IBInspectable open var bottomSide: UIColor? = nil
    
    var isInterfaceBuilder: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func prepareForInterfaceBuilder() {
        self.isInterfaceBuilder = true
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if !isInterfaceBuilder {
            if let side = topSide {
                aa_addTopBorderWithColor(color: side, width: lineWidth, paddingX: paddingX, paddingY: paddingY)
            } else if let side = leftSide {
                aa_addLeftBorderWithColor(color: side, width: lineWidth, paddingX: paddingX, paddingY: paddingY)
            } else if let side = rightSide {
                aa_addRightBorderWithColor(color: side, width: lineWidth, paddingX: paddingX, paddingY: paddingY)
            } else if let side = bottomSide {
                aa_addBottomBorderWithColor(color: side, width: lineWidth, paddingX: paddingX, paddingY: paddingY)
            }
        }
    }
}
