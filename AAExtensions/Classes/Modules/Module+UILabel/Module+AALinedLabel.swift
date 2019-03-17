//
//  Module+AALinedLabel.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

public class AALinedLabel: UIView {
    
    @IBInspectable var lineInsideOffset: CGFloat = 20
    @IBInspectable var lineOutsideOffset: CGFloat = 20
    @IBInspectable var lineHeight: CGFloat = 1
    @IBInspectable var lineColor: UIColor = .gray
    @IBInspectable var labelText: String = "Some Label" {
        didSet {
            label.text = labelText
        }
    }
    
    public let label = UILabel()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLabel()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLabel()
    }
    convenience init() {self.init(frame: CGRect.zero)}
    
    func initLabel() {
        label.text = labelText
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1, constant: 0)
        let bot = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: 0)
        let lead = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .lessThanOrEqual, toItem: label, attribute: .leading, multiplier: 1, constant: 0)
        let trail = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: label, attribute: .trailing, multiplier: 1, constant: 0)
        let centerX = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: label, attribute: .centerX, multiplier: 1, constant: 0)
        
        addSubview(label)
        addConstraints([top, bot, lead, trail, centerX])
        isOpaque = false
    }
    
    override public func draw(_ rect: CGRect) {
        let lineWidth = label.frame.minX - rect.minX - lineInsideOffset - lineOutsideOffset
        if lineWidth <= 0 {return}
        
        let lineLeft = UIBezierPath(rect: CGRect(x: rect.minX + lineOutsideOffset, y: rect.midY, width: lineWidth, height: 1))
        let lineRight = UIBezierPath(rect: CGRect(x: label.frame.maxX + lineInsideOffset, y: rect.midY, width: lineWidth, height: 1))
        
        lineLeft.lineWidth = lineHeight
        lineColor.set()
        lineLeft.stroke()
        
        lineRight.lineWidth = lineHeight
        lineColor.set()
        lineRight.stroke()
    }
}
