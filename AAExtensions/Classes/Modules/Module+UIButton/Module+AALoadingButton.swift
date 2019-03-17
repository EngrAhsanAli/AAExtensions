//
//  Module+LoadingButton.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

// UIButton Indicator

fileprivate var originalButtonText: String?
fileprivate var activityIndicator: UIActivityIndicatorView!

public extension UIButton {
    
    func aa_showLoading(_ color: UIColor = .lightGray) {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)
        
        if (activityIndicator == nil) {
            let _activityIndicator = UIActivityIndicatorView()
            _activityIndicator.hidesWhenStopped = true
            _activityIndicator.color = color
            activityIndicator = _activityIndicator
        }
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
        activityIndicator.startAnimating()
    }
    
    func aa_hideLoading() {
        self.setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
        originalButtonText = nil
        activityIndicator = nil
    }
    
}
