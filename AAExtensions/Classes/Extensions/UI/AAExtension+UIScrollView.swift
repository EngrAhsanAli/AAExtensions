//
//  Extension+UIScrollView.swift
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


// MARK:- UIScrollView
public extension AA where Base: UIScrollView {
    
    @discardableResult
    func addRefreshControl(_ completion: @escaping (() -> ())) -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        if #available(iOS 10.0, *) { base.refreshControl = refreshControl }
        else { base.addSubview(refreshControl) }
        refreshControl.aa.addAction(for: .valueChanged) { _ in
            refreshControl.endRefreshing()
            if refreshControl.isRefreshing { completion() }
        }
        return refreshControl
    }
    
    func scrollToBottomOffset(_ animated: Bool) {
        if base.contentSize.height < base.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: base.contentSize.height - base.bounds.size.height)
        base.setContentOffset(bottomOffset, animated: animated)
    }
    
    func isOnBottom(with distance: Float = 10) -> Bool {
        let y: Float = Float(base.contentOffset.y) + Float(base.bounds.size.height) + Float(base.contentInset.bottom)
        let height = Float(base.contentSize.height)
        return y > height + distance
    }
}


