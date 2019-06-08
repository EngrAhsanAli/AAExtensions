//
//  Module+AALabelParagraph.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
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
open class AALabelParagraph: UILabel {
    
    @IBInspectable open var isHorizontal: Bool = true
    @IBInspectable open var firstColor: UIColor = .black
    @IBInspectable open var secondOther: UIColor = .black
    @IBInspectable open var tabsSize: Int = 1
    
    func setAttrText(first: [String], second: [String]) {
        
        guard first.count == second.count else { return }
        
        var tabs = ""
        for _ in 0...tabsSize {
            tabs += "\t"
        }
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        for tabStop in paragraph.tabStops {
            paragraph.removeTabStop(tabStop)
        }
        if (!isHorizontal) {
            paragraph.addTabStop(NSTextTab(textAlignment: .right, location: 150.0, options: [:] ))
        }
        
        let text = NSMutableAttributedString()
        let leftAttributes = [
            NSAttributedString.Key.foregroundColor: firstColor,
            NSAttributedString.Key.paragraphStyle: paragraph
        ]
        let rightAttributes = [
            NSAttributedString.Key.foregroundColor: secondOther,
            NSAttributedString.Key.paragraphStyle: paragraph
        ]
        
        first.enumerated().forEach { (index, elem) in
            
            text.append(NSAttributedString(string: elem, attributes: leftAttributes))
            text.append(NSAttributedString(string: "\t\(second[index])\t\(tabs)", attributes: rightAttributes))
            if !isHorizontal, index != first.count - 1 {
                text.append(NSAttributedString(string: "\n"))
            }
        }
        
        self.attributedText = text
        
    }
    
    
}

