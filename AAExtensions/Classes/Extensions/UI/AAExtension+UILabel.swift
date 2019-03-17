//
//  Extension+UILabel.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

// MARK:- UILabel
public extension UILabel {
    func aa_getHeight(for string: String) -> CGFloat {
        let textStorage = NSTextStorage(string: string)
        let textContainter = NSTextContainer(size: CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainter)
        textStorage.addLayoutManager(layoutManager)
        textStorage.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, textStorage.length))
        textContainter.lineFragmentPadding = 0.0
        layoutManager.glyphRange(for: textContainter)
        return layoutManager.usedRect(for: textContainter).size.height
    }
}

