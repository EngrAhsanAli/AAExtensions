//
//  Extension+UIScrollView.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

// MARK:- ScrollView
public extension UIScrollView {
    func aa_addRefreshControl(_ completion: @escaping (() -> ())) -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        if #available(iOS 10.0, *) {
            self.refreshControl = refreshControl
        } else {
            self.addSubview(refreshControl)
        }
        refreshControl.aa_addAction(for: .valueChanged) {
            guard refreshControl.isRefreshing else {
                refreshControl.endRefreshing()
                return
            }
            refreshControl.endRefreshing()
            completion()
        }
        return refreshControl
    }
}


