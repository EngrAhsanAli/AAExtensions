//
//  Module+AAPlaceholderTextView.swift
//  AAExtensions
//
//  Created by MacBook Pro on 17/03/2019.
//

import UIKit

public class AAPlaceholderTextView: UITextView {
    
    @IBInspectable open var placeholderColor: UIColor = .lightGray
    @IBInspectable open var placeholderText: String = ""
    
    override public var font: UIFont? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var contentInset: UIEdgeInsets {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var textAlignment: NSTextAlignment {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var text: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var attributedText: NSAttributedString? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    private func setUp() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.textChanged(notification:)),
                                               name: Notification.Name("UITextViewTextDidChangeNotification"),
                                               object: nil)
    }
    
    @objc func textChanged(notification: NSNotification) {
        setNeedsDisplay()
    }
    
    func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        var x = contentInset.left + 4.0
        var y = contentInset.top  + 9.0
        let w = frame.size.width - contentInset.left - contentInset.right - 16.0
        let h = frame.size.height - contentInset.top - contentInset.bottom - 16.0
        
        if let style = self.typingAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle {
            x += style.headIndent
            y += style.firstLineHeadIndent
        }
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    override public func draw(_ rect: CGRect) {
        if text!.isEmpty && !placeholderText.isEmpty {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = textAlignment
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue) : font!,
                NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue) : placeholderColor,
                NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue)  : paragraphStyle]
            
            placeholderText.draw(in: placeholderRectForBounds(bounds: bounds), withAttributes: attributes)
        }
        super.draw(rect)
    }
}

