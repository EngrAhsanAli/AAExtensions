//
//  Extension+UITableView.swift
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



//MARK:- UITableView
public extension UITableView {
    
    var aa_lastSection: Int {
        return numberOfSections > 0 ? numberOfSections - 1 : 0
    }
    
    func aa_reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    func aa_safeScrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard indexPath.section < numberOfSections else { return }
        guard indexPath.row < numberOfRows(inSection: indexPath.section) else { return }
        scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    func aa_insertRowAtBottom(_ scrollToBottom: Bool = true) {
        DispatchQueue.main.async {
            let lastSection = self.numberOfSections - 1
            let lastRowIndex = self.numberOfRows(inSection: lastSection)
            let indexPath = IndexPath(row: lastRowIndex, section: lastSection)
            self.insertRows(at: [indexPath], with: .none)
            if scrollToBottom {
                self.scrollToRow(at: indexPath, at: .none, animated: false)
            }
        }
    }
    
    func aa_reloadToLastRow(_ lastRow: Int) {
        DispatchQueue.main.async {
            let lastSection = self.numberOfSections - 1
            let lastRowIndex = self.numberOfRows(inSection: lastSection)
            guard lastRowIndex > lastRow else { return }
            let indexPath = IndexPath(row: lastRowIndex - lastRow, section: lastSection)
            self.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func aa_scrollToBottom(_ animated: Bool = true) {
        DispatchQueue.main.async {
            if (self.numberOfSections > 0) {
                let lastSection = self.numberOfSections - 1
                let rows = self.numberOfRows(inSection: lastSection)
                if (rows > 0 ) {
                    let lastRowIndex = rows - 1
                    let indexPath = IndexPath(row: lastRowIndex, section: lastSection)
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
            }
        }
    }
    
    func aa_setOffsetToBottom(animated: Bool) {
        self.setContentOffset(CGPoint(x: 0, y: self.contentSize.height - self.frame.size.height), animated: true)
    }
    
    func aa_showMenuOnLongPress() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressMenuController))
        longPressGesture.minimumPressDuration = 1.0
        addGestureRecognizer(longPressGesture)
    }
    
    @objc private func onLongPressMenuController(_ gestureRecognizer: UIGestureRecognizer) {
        let menu = UIMenuController.shared
        if !menu.isMenuVisible && gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self)
            if let indexPath = indexPathForRow(at: touchPoint) {
                self.becomeFirstResponder()
                self.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                menu.setTargetRect(rectForRow(at: indexPath), in: self)
                menu.setMenuVisible(true, animated: true)
            }
        }
        
    }
    
    
}

