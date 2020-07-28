//
//  Extension+UIViewController.swift
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


import AVKit

// MARK:- UIViewController
public extension UIViewController {
    
    class func aa_replaceRootViewController (
        to viewController: UIViewController,
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        options: UIView.AnimationOptions = .transitionFlipFromRight,
        _ completion: AACompletionVoid? = nil) {
        
        let keyWindow = UIApplication.shared.keyWindow!
        
        guard animated else {
            keyWindow.rootViewController = viewController
            completion?()
            return
        }
        
        UIView.transition(with: keyWindow, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            keyWindow.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }, completion: { _ in
            completion?()
        })
    }
    
    var aa_topViewController: UIViewController {
        switch self {
        case is UINavigationController:
            return (self as! UINavigationController).visibleViewController?.aa_topViewController ?? self
        case is UITabBarController:
            return (self as! UITabBarController).selectedViewController?.aa_topViewController ?? self
        default:
            return presentedViewController?.aa_topViewController ?? self
        }
    }
    
    var aa_tabbarHeight: CGFloat {
        return (self.tabBarController?.tabBar.frame.size.height)!
    }

    func aa_push(_ vc: UIViewController, result: ((Any) -> ())? = nil)  {
        vc.aa_callBack = result
        let navigation = (self as? UINavigationController) ?? navigationController
        navigation?.pushViewController(vc, animated: true)
    }
    
    func aa_pop(_ vc: UIViewController, result: ((Any) -> ())? = nil)  {
        vc.aa_callBack = result
        let navigation = (self as? UINavigationController) ?? navigationController
        navigation?.popViewController(animated: true)
    }
    
    func aa_pop(to n: Int, result: Any? = nil) {
        
        guard let navigation = (self as? UINavigationController) ?? navigationController else {
            return
        }
        
        if let result = result, let callback = aa_callBack {
            callback(result)
        }
        
        let viewControllers = navigation.viewControllers
        if let destination = viewControllers[aa_optional: viewControllers.count - (n + 1)] {
            navigation.popToViewController(destination, animated: true)
        }
        else {
            navigation.popToRootViewController(animated: true)
        }
        
    }
    
    func aa_present(_ vc: UIViewController, result: ((Any) -> ())? = nil)  {
        vc.aa_callBack = result
        present(vc, animated: true, completion: nil)
    }
    
    
    func aa_dismiss(_ result: Any? = nil) {
        if let result = result, let callback = aa_callBack {
            callback(result)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @discardableResult
    func aa_addWebView(_ urlString: String) -> UIWebView {
        let webView = UIWebView()
        if #available(iOS 9.0, *) {
            view.aa_addConstrainedSubview(webView)
        } else {
            view.aa_addAndFitSubview(webView)
        }
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        webView.loadRequest(request)
        return webView
    }
    
    func aa_pushWebView(_ url: String, bgColor: UIColor, completion: ((UIViewController, UIWebView) -> ())) {
        
        let vc = UIViewController()
        vc.view.backgroundColor = bgColor
        let webView = vc.aa_addWebView(url)
        webView.isOpaque = false
        webView.backgroundColor = bgColor
        completion(vc, webView)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Callbacks the value stored and removes the object immediately
    var aa_callBack: ((Any?) -> ())?  {
        get {
            let value = objc_getAssociatedObject(self, &AA_AssociationKeyAnyCallback) as? (Any?) -> ()
            objc_removeAssociatedObjects(self) // Enhanced to keep memory optimization
            return value
        }
        set {
            objc_setAssociatedObject(self, &AA_AssociationKeyAnyCallback, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func aa_selectTab(_ index: Int) {
        guard let tabbar = self.tabBarController,
            let nav = tabbar.viewControllers?[aa_optional: index] as? UINavigationController
            else { return }
        tabbar.selectedIndex = index
        nav.popToRootViewController(animated: true)
    }
    
    func aa_rightBarButton(_ image: String, selector: Selector) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: image),
            style: .plain,
            target: self,
            action: selector)
    }
    
    func aa_showActionSheet(_ title: String? = nil, message:String? = nil, actions: [[String:UIAlertAction.Style]], completion: @escaping (_ index: Int) -> ()) {
        let alertViewController = UIAlertController(title:title, message: message, preferredStyle: .actionSheet)
        for (index,action) in actions.enumerated() {
            for actionContent in action {
                let action = UIAlertAction(title: actionContent.key, style: actionContent.value) { (action) in
                    completion(index)
                }
                alertViewController.addAction(action)
            }
        }
        alertViewController.popoverPresentationController?.sourceView = self.view
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func aa_showAlert(_ title: String, text: String,
                      doneText: String, onDismiss: (() -> ())? = nil) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: doneText, style: .default) {
            (action: UIAlertAction) in
            onDismiss?()
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func aa_showAlert(title: String?, message: String?,
                      doneText: String, cancelText: String,
                      textFields: Int, onTextFieldAdded:(([UITextField]) -> ())?,
                      onComplete: @escaping (([String]) -> ()), onDismiss: AACompletionVoid? = nil) {
        
        guard textFields > 0 else {
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: { _ in
            onDismiss?()
        }))
        
        let saveAction = UIAlertAction(title: doneText, style: .default, handler: { _ in
            guard let textFields = alert.textFields else { return }
            let values = textFields.compactMap { $0.text }
            onComplete(values)
        })
        alert.addAction(saveAction)
        
        for _ in 0..<textFields {
            alert.addTextField(configurationHandler: nil)
        }
        onTextFieldAdded?(alert.textFields!)
        present(alert, animated: true, completion: nil)
    }
    
    @discardableResult
    func aa_playVideo(_ url: URL) -> AVPlayerViewController {
        let player = AVPlayer(url: url)
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        self.present(playerVC, animated: true) {
            player.play()
        }
        return playerVC
    }
    
    func aa_canPerformSegue(identifier: String, sender: Any? = nil) -> Bool {
        guard let identifiers = value(forKey: "storyboardSegueTemplates") as? [NSObject] else {
            return false
        }
        let canPerform = identifiers.contains { (object) -> Bool in
            if let id = object.value(forKey: "_identifier") as? String {
                return id == identifier
            }else{
                return false
            }
        }
        return canPerform
    }

    func aa_presentThis(_ forced: Bool = false, result: ((Any?) -> ())?) {

        guard let root = UIApplication.shared.keyWindow?.rootViewController else { return }
        self.aa_callBack = result
        
        guard !forced else {
            root.present(self, animated: true, completion: nil)
            return
        }
        
        if let _vc = root.presentedViewController as? UINavigationController {
            _vc.pushViewController(self, animated: true)
        }
        else if let _vc = root as? UINavigationController {
            _vc.pushViewController(self, animated: true)
        }
        else if let _vc = root.presentedViewController {
             _vc.present(self, animated: true, completion: nil)
        }
        else {
            root.present(self, animated: true, completion: nil)
        }
    }
    
    func aa_dismissThis(_ result: Any? = nil) {
        
        guard let root = UIApplication.shared.keyWindow?.rootViewController else { return }
        
        if let result = result, let callback = aa_callBack {
            callback(result)
        }
        
        if let _vc = root.presentedViewController as? UINavigationController {
            _vc.popViewController(animated: true)
        }
        else if let _vc = root as? UINavigationController {
            _vc.popViewController(animated: true)
        }
        else if let _vc = root.presentedViewController {
            _vc.dismiss(animated: true, completion: nil)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func aa_rightBarButton(_ image: UIImage, _ closure: @escaping AACompletionVoid) {
        self.navigationItem.rightBarButtonItem = AABindableBarButton(image: image, actionHandler: closure)
    }
    
    func aa_leftBarButton(_ image: UIImage, _ closure: @escaping AACompletionVoid) {
        self.navigationItem.leftBarButtonItem = AABindableBarButton(image: image, actionHandler: closure)
    }
    
    func aa_leftBarButton(_ title: String, font: UIFont, _ closure: @escaping AACompletionVoid) {
        let color = navigationController?.navigationBar.barTintColor ?? .white
        self.navigationItem.leftBarButtonItem = AABindableBarButton(title: title, font: font, foregroundColor: color, actionHandler: closure)
    }
    
    func aa_rightBarButton(_ title: String, font: UIFont, _ closure: @escaping AACompletionVoid) {
        let color = navigationController?.navigationBar.barTintColor ?? .white
        self.navigationItem.rightBarButtonItem = AABindableBarButton(title: title, font: font, foregroundColor: color, actionHandler: closure)
    }
    
}


public extension UIViewController {
    
    // Self is Parent
    func aa_embed(container:UIView,
                         child:UIViewController,
                         previous:UIViewController?) {
        
        if let previous = previous {
            previous.aa_removeFromParent()
        }
        child.willMove(toParent: self)
        self.addChild(child)
        container.addSubview(child.view)
        child.didMove(toParent: parent)
        child.view.frame = CGRect(x: 0, y: 0, width: container.frame.size.width, height: container.frame.size.height)
    }
    
    func aa_embed(withIdentifier id:String,
                         parent:UIViewController,
                         container:UIView,
                         completion:((UIViewController)->Void)? = nil) {
        
        let vc = parent.storyboard!.instantiateViewController(withIdentifier: id)
        self.aa_embed(
            container: container,
            child: vc,
            previous: parent.children.first
        )
        completion?(vc)
    }
    
    func aa_removeFromParent(){
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}


public extension AA where Base: UIViewController {

    func setCurvedNavigation(_ model: AAGradientModel, curveRadius: CGFloat = 17,
                             shadowColor: UIColor = .darkGray, shadowRadius: CGFloat = 4,
                             heightOffset: CGFloat = 0, curveHeight: CGFloat) {
        
        let viewName = "AACurvedView"
        let instance = self.base
        guard let navigationController = instance.navigationController else { return }
        
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let gradient: CAGradientLayer = {
            let gradient = CAGradientLayer()
            gradient.frame = navigationController.navigationBar.frame
            gradient.frame.size.height = curveHeight
            gradient.colors = model.colors.map { $0.cgColor }
            gradient.startPoint = model.startPoint.point
            gradient.endPoint = model.endPoint.point
            return gradient
        }()
        
        gradient.mask = {
            
            let screenWidth = UIScreen.main.bounds.size.width
            var totalHeight = UIApplication.shared.statusBarFrame.height + navigationController.navigationBar.frame.size.height + heightOffset
            
            totalHeight += instance.view.aa_statusBarSize.height
            
            let y1: CGFloat = totalHeight
            let y2: CGFloat = totalHeight + curveRadius
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0.0, y: y1))
            path.addCurve(to: CGPoint(x: screenWidth / 2 , y: y2), controlPoint1: CGPoint(x: 0, y: y1), controlPoint2: CGPoint(x:screenWidth / 4, y: y2))
            path.addCurve(to: CGPoint(x: screenWidth, y: y1), controlPoint1: CGPoint(x: screenWidth * 0.75, y: y2), controlPoint2: CGPoint(x: screenWidth, y: y1))
            path.addLine(to: CGPoint(x: screenWidth, y: 0))
            path.addLine(to: .zero)
            
            let shape = CAShapeLayer()
            shape.frame = instance.view.frame
            shape.path =  path.cgPath
            return shape
            
        }()
        
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = .zero
        shadowLayer.shadowRadius = shadowRadius
        shadowLayer.shadowOpacity = 0.8
        shadowLayer.backgroundColor = UIColor.white.cgColor
        shadowLayer.insertSublayer(gradient, at: 0)
        shadowLayer.name = viewName
        
        navigationController.view.layer.insertSublayer(shadowLayer, at: 1)
        
    }
    
   
    
    
}
