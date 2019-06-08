//
//  Module+AAExpandableLabel.swift
//  AAExtensions
//
//  Created by Ahsan Ali on 09/06/2019.
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


@available(iOS 9.0, *)
@IBDesignable
open class AAExpandableLabel: UILabel {
    
    @IBInspectable open var defaultLines: Int = 3
    
    @IBInspectable open var readMoreText: String = " ... Read more" {
        didSet {
            button.setTitle(readMoreText, for: .normal)
        }
    }
    
    @IBInspectable open var readLessText: String = " Read less" {
        didSet {
            button.setTitle(readLessText, for: .selected)
        }
    }
    
    @IBInspectable open var expandedColor: UIColor = .gray {
        didSet {
            button.setTitleColor(expandedColor, for: .normal)
        }
    }
    
    @IBInspectable open var collapseColor: UIColor = .blue {
        didSet {
            button.setTitleColor(collapseColor, for: .selected)
        }
    }
    
    public let button = UIButton()
    
    open var isExpaded = false
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let buttonAray =  self.superview?.subviews.filter({ (v) -> Bool in
            return v ==  self.button
        })
        
        if buttonAray?.isEmpty == true {
            self.addReadMoreButton()
        }
    }
    
    func addReadMoreButton() {
        
        let theNumberOfLines = numberOfLinesInLabel(yourString: self.text ?? "", labelWidth: self.frame.width, labelHeight: self.frame.height, font: self.font)
        self.numberOfLines =  self.isExpaded ? 0 : defaultLines
        
        if theNumberOfLines >  defaultLines {
            
            (readMoreText = readMoreText)
            (readLessText = readLessText)
            (expandedColor = expandedColor)
            (collapseColor = collapseColor)
            self.numberOfLines = defaultLines
            button.titleLabel?.font = self.font.bold()
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            self.superview?.addSubview(button)
            self.superview?.bringSubviewToFront(button)
            button.isSelected = self.isExpaded
            button.sizeToFit()
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                button.bottomAnchor.constraint(equalTo:  self.bottomAnchor, constant: +button.intrinsicContentSize.height)
                ])
        } else {
            self.numberOfLines = defaultLines
        }
    }
    
    func numberOfLinesInLabel(yourString: String, labelWidth: CGFloat, labelHeight: CGFloat, font: UIFont) -> Int {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = labelHeight
        paragraphStyle.maximumLineHeight = labelHeight
        paragraphStyle.lineBreakMode = .byTruncatingTail
        let attributes: [NSAttributedString.Key: AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font, NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue): paragraphStyle]
        let constrain = CGSize(width: labelWidth, height: CGFloat(Float.infinity))
        let size = yourString.size(withAttributes: attributes)
        let stringWidth = size.width
        let numberOfLines = ceil(Double(stringWidth/constrain.width))
        return Int(numberOfLines)
    }
    
    @objc func buttonTapped(sender : UIButton) {
        
        self.isExpaded = !isExpaded
        sender.isSelected =   self.isExpaded
        
        self.numberOfLines =  sender.isSelected ? 0 : defaultLines
        
        self.layoutIfNeeded()
        
        var _view :UIView? = self
        var _cell :UITableViewCell?
        
        while _view?.superview != nil  {
            
            if let cell = _view as? UITableViewCell  {
                _cell = cell
            }
            
            if let tableView = (_view as? UITableView)  {
                if tableView.indexPath(for: _cell ?? UITableViewCell()) != nil {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
                return
            }
            
            _view = _view?.superview
        }
        
        
    }
    
}
