//
//  Module+AARoundedButton.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

public class AARoundedButton: UIButton {
    
    public var buttonColor: UIColor = .blue {
        didSet {
            self.layer.borderColor = buttonColor.cgColor
            self.setTitleColor(buttonColor, for: .normal)
        }
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderWidth = 2.0
        self.clipsToBounds = true
        self.setTitleColor(.white, for: .highlighted)
        (buttonColor = buttonColor)
    }
    
    override public var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? buttonColor : .clear
        }
    }
    
}
