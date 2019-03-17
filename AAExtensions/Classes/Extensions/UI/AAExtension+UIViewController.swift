//
//  Extension+UIViewController.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

import UIKit

// MARK:- UIViewController
public extension UIViewController {
    
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
    
    var aa_callBack: ((Any) -> Void)?  {
        get {
            return objc_getAssociatedObject(self, &AA_AssociationKeyAnyCallback) as! ((Any) -> Void)?
        }
        set {
            objc_setAssociatedObject(self, &AA_AssociationKeyAnyCallback, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func aa_selectTab(_ index: Int) {
        guard let tabbar = self.tabBarController else { return }
        tabbar.selectedIndex = index
        let nav = tabbar.viewControllers![index] as! UINavigationController
        guard nav.viewControllers.count > 1 else { return }
        for _ in 0...nav.viewControllers.count - 1 {
            nav.popViewController(animated: false)
        }
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
        let w = container.frame.size.width
        let h = container.frame.size.height
        child.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
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
