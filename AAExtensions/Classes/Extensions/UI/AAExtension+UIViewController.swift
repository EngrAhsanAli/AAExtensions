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
    
    /// Get View Controller from given stoaryboard with same ID as ViewController class
    class func aa_viewController<T: UIViewController>(_ viewController: T.Type, instance: ((T) -> ())? = nil, inStroryboard: UIStoryboard? = nil) -> T? {
        
        var storyboard: UIStoryboard
        if let _storyboard = inStroryboard { storyboard = _storyboard }
        else { storyboard = UIStoryboard(name: String(describing: viewController), bundle: nil) }
        
        guard let vc = (inStroryboard ?? storyboard).aa_viewController(withClass: viewController) else { return nil }
        instance?(vc)
        return vc
    }
    
    class func aa_replaceRootViewController(
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
    
    func aa_pushViewController(_ vc: UIViewController)  {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func aa_dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
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
    
    var aa_callBack: ((Any?) -> Void)?  {
        get {
            return objc_getAssociatedObject(self, &AA_AssociationKeyAnyCallback) as! ((Any?) -> Void)?
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: image),
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
    
    func aa_showAlert(_ title: String,
                      text: String,
                      doneText: String = "OK",
                      onDismiss: (() -> ())? = nil) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: doneText, style: .default) {
            (action: UIAlertAction) in
            onDismiss?()
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func aa_showAlert(title: String?,
                   message: String?,
                   doneText: String = "Done",
                   cancelText: String = "Cancel",
                   numTextFields: Int,
                   applyEmptyValidation: Bool = true,
                   onTextFieldAdded: @escaping ((UITextField, UIAlertAction) -> ()),
                   onComplete: @escaping (([UITextField]) -> ()),
                   onDismiss: (() -> ())? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: { _ in
            onDismiss?()
        }))
        
        let saveAction = UIAlertAction(title: doneText, style: .destructive, handler: { _ in
            guard let textFields = alert.textFields else { return }
            onComplete(textFields)
        })
        alert.addAction(saveAction)
        saveAction.isEnabled = false
        
        for _ in 0..<numTextFields {
            alert.addTextField { textField in
                if applyEmptyValidation {
                    NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { (notification) in
                        saveAction.isEnabled = (textField.text?.count ?? 0) > 0
                    }
                }
                onTextFieldAdded(textField, saveAction)
            }
        }
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

    func aa_presentCurrentViewController(_ vc: UIViewController) {

        guard let root = UIApplication.shared.keyWindow?.rootViewController else { return }

        if let _vc = root.presentedViewController as? UINavigationController {
            _vc.pushViewController(vc, animated: true)
        }
        else if let _vc = root as? UINavigationController {
            _vc.pushViewController(vc, animated: true)
        }
        else if let _vc = root.presentedViewController {
             _vc.present(vc, animated: true, completion: nil)
        }
        else {
            root.present(vc, animated: true, completion: nil)
        }
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
