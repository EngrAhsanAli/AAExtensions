//
//  Module+AAProgressWebView.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

public class AAProgressWebView: UIWebView, UIWebViewDelegate {
    
    open var progressView: UIProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(viewController: UIViewController, progressView: UIProgressView) {
        self.init(frame: viewController.view.frame)
        self.progressView = progressView
        self.delegate = self
        
    }
    
    open func loadURL(_ urlString: String) {
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        loadRequest(request)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func webViewDidStartLoad(_ webView: UIWebView) {
        self.progressView.setProgress(0.1, animated: false)
    }
    
    
    private func webViewDidFinishLoad(_ webView: UIWebView) {
        self.progressView.setProgress(1.0, animated: true)
    }
    
    private func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.progressView.setProgress(1.0, animated: true)
    }
    
    
    
}

