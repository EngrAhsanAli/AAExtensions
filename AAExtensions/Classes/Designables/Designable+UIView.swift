//
//  Designable+UIView.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

//MARK:- UIView IBDesignable
@IBDesignable
public extension UIView {
    @IBInspectable var AABorderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
    }
    
    @IBInspectable var AABorderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var AACornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var AACornerPercent: CGFloat {
        get {
            return self.AACornerPercent
        }
        set (value) {
            layer.cornerRadius = frame.width * value
        }
    }
    
    @IBInspectable
    var AAShadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var AAShadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var AAShadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var AAShadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable public var AABackground: UIImage? {
        get { return  self.AABackground }
        set (newValue) {
            guard let background = newValue else { return }
            let imageview = UIImageView(frame: UIScreen.main.bounds)
            imageview.contentMode =  .scaleAspectFill
            imageview.clipsToBounds = true
            imageview.image = background
            addSubview(imageview)
            sendSubviewToBack(imageview)
        }
    }
    
    @IBInspectable var AACircular: Bool {
        get { return self.AACircular }
        set (value) {
            guard value else { return }
            layer.cornerRadius = bounds.height * 0.5
            clipsToBounds = layer.cornerRadius > 0
        }
    }
    
}
