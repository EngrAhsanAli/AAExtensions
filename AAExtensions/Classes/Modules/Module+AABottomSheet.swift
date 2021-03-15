//
//  Module+AABottomSheet.swift
//  AAExtensions
//
//  Created by Muhammad Ahsan Ali on 2020/08/24.
//

import UIKit

public class AABottomSheet: NSObject {
    
    // MARK: - Private properties
    
    private static var actionSheets = [AABottomSheet]()
    private static let kMarginSide: CGFloat = 8
    private static let kItemInterval: CGFloat = 8
    private static let kMarginTop: CGFloat = 20
    private var items: [SheetItem]?
    private let maskView = UIView()
    private let itemContainerView = UIView()
    private var closeBlock: (() -> Void)?
    
    @objc public enum SheetPosition: Int {
        case bottom
        case top
    }
    
    // MARK: - Public properties
    
    public var maskColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    public var defaultCornerRadius: CGFloat = 4
    public var position: SheetPosition = .bottom
    public func showInView(_ targetView: UIView, items: [SheetItem], closeBlock: (() -> Void)? = nil) {
        // Save instance to reaction until closing this sheet
        AABottomSheet.actionSheets.append(self)
        
        let targetBounds = targetView.bounds
        
        self.closeBlock = closeBlock
        
        // mask view
        let maskViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(AABottomSheet.maskViewWasTapped))
        self.maskView.addGestureRecognizer(maskViewTapGesture)
        self.maskView.frame = targetBounds
        self.maskView.backgroundColor = maskColor
        targetView.addSubview(self.maskView)
        
        // set items
        for subview in self.itemContainerView.subviews {
            subview.removeFromSuperview()
        }
        var currentPosition: CGFloat = 0
        let safeAreaTop: CGFloat
        let safeAreaBottom: CGFloat
        if #available(iOS 11.0, *) {
            safeAreaTop = targetView.safeAreaInsets.top
            safeAreaBottom = targetView.safeAreaInsets.bottom
        } else {
            safeAreaTop = AABottomSheet.kMarginTop
            safeAreaBottom = 0
        }
        var availableHeight = targetBounds.height - safeAreaTop - safeAreaBottom
        
        // Calculate height of items
        for item in items {
            availableHeight = availableHeight - item.height - AABottomSheet.kItemInterval
        }
        
        for item in items {
            // Apply height of items
            if availableHeight < 0 {
                let reduceNum = min(item.height, -availableHeight)
                item.height -= reduceNum
                availableHeight += reduceNum
                
                if item.height <= 0 {
                    availableHeight += AABottomSheet.kItemInterval
                    continue
                }
            }
            
            // Add views
            switch (item.type) {
            case .button:
                let button = UIButton()
                button.layer.cornerRadius = defaultCornerRadius
                button.frame = CGRect(
                    x: AABottomSheet.kMarginSide,
                    y: currentPosition,
                    width: targetBounds.width - (AABottomSheet.kMarginSide * 2),
                    height: item.height)
                button.setTitle(item.label, for: UIControl.State())
                button.backgroundColor = item.backgroundColor
                button.setTitleColor(item.textColor, for: UIControl.State())
                if let font = item.font {
                    button.titleLabel?.font = font
                }
                if let _ = item.selectAction {
                    button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AABottomSheet.buttonWasTapped(_:))))
                }
                item.element = button
                self.itemContainerView.addSubview(button)
                currentPosition = currentPosition + item.height + AABottomSheet.kItemInterval
            case .view:
                if let view = item.view {
                    let containerView = ActionSheetItemView(frame: CGRect(
                        x: AABottomSheet.kMarginSide,
                        y: currentPosition,
                        width: targetBounds.width - (AABottomSheet.kMarginSide * 2),
                        height: item.height))
                    containerView.layer.cornerRadius = defaultCornerRadius
                    containerView.addSubview(view)
                    view.frame = view.bounds
                    self.itemContainerView.addSubview(containerView)
                    item.element = view
                    currentPosition = currentPosition + item.height + AABottomSheet.kItemInterval
                }
            }
        }
        let positionX: CGFloat = 0
        var positionY: CGFloat = targetBounds.minY + targetBounds.height - currentPosition - safeAreaBottom
        var moveY: CGFloat = positionY
        if self.position == .top {
            positionY = AABottomSheet.kItemInterval
            moveY = -currentPosition
        }
        self.itemContainerView.frame = CGRect(
            x: positionX,
            y: positionY,
            width: targetBounds.width,
            height: currentPosition)
        self.items = items
        
        // Show animation
        self.maskView.alpha = 0
        targetView.addSubview(self.itemContainerView)
        self.itemContainerView.transform = CGAffineTransform(translationX: 0, y: moveY)
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: { () -> Void in
                        self.maskView.alpha = 1
                        self.itemContainerView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    public func dismiss() {
        guard let targetView = self.itemContainerView.superview else {
            return
        }
        
        // Hide animation
        self.maskView.alpha = 1
        var moveY: CGFloat = targetView.bounds.height - self.itemContainerView.frame.origin.y
        if self.position == .top {
            moveY = -self.itemContainerView.frame.height
        }
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: { () -> Void in
                        self.maskView.alpha = 0
                        self.itemContainerView.transform = CGAffineTransform(translationX: 0, y: moveY)
        }) { (result: Bool) -> Void in
            // Remove views
            self.itemContainerView.removeFromSuperview()
            self.maskView.removeFromSuperview()
            
            // Remove this instance
            for i in 0 ..< AABottomSheet.actionSheets.count {
                if AABottomSheet.actionSheets[i] == self {
                    AABottomSheet.actionSheets.remove(at: i)
                    break
                }
            }
            
            self.closeBlock?()
        }
    }
    
    // MARK: - Private methods
    
    @objc private func maskViewWasTapped() {
        self.dismiss()
    }
    
    @objc private func buttonWasTapped(_ sender: AnyObject) {
        guard let items = self.items else {
            return
        }
        for item in items {
            guard
                let element = item.element,
                let gestureRecognizer = sender as? UITapGestureRecognizer else {
                    continue
            }
            if element == gestureRecognizer.view {
                item.selectAction?(self)
            }
        }
    }
    
    private class ActionSheetItemView: UIView {
        var subview: UIView?
        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
            self.setting()
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setting()
        }
        
        init() {
            super.init(frame: CGRect.zero)
            self.setting()
        }
        
        func setting() {
            self.clipsToBounds = true
        }
        
        override func addSubview(_ view: UIView) {
            super.addSubview(view)
            self.subview = view
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            if let subview = self.subview {
                subview.frame = self.bounds
            }
        }
    }
    
    public class SheetItem: NSObject {
        
        // MARK: - Public properties
        public var type: SheetType = .button
        public var height: CGFloat = SheetItem.defaultHeight
        public static let defaultHeight: CGFloat = 44
        
        // type = .View
        public var view: UIView?
        
        // type = .Button
        public var label: String?
        public var textColor: UIColor = UIColor(red: 0, green: 0.47, blue: 1.0, alpha: 1.0)
        public var backgroundColor: UIColor = UIColor.white
        public var font: UIFont? = nil
        public var selectAction: ((_ actionSheet: AABottomSheet) -> Void)? = nil
        
        // MARK: - Private properties
        fileprivate var element: UIView? = nil
        
        public convenience init(type: SheetType,
                                height: CGFloat = SheetItem.defaultHeight) {
            self.init()
            
            self.type = type
            self.height = height
        }
        
        @objc public enum SheetType: Int {
            case button
            case view
        }
        
    }
}
