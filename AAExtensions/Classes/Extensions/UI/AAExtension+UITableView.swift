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


public extension AA where Base: UITableView {
    
    var lastSection: Int { base.numberOfSections > 0 ? base.numberOfSections - 1 : 0 }
    
    func safeScrollToRow(at indexPath: IndexPath, scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard indexPath.section < base.numberOfSections,
              indexPath.row < base.numberOfRows(inSection: indexPath.section) else { return }
        base.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    func insertRowAtBottom(_ scrollToBottom: Bool = true) {
        DispatchQueue.main.async {
            let lastSection = base.numberOfSections - 1
            let lastRowIndex = base.numberOfRows(inSection: lastSection)
            let indexPath = IndexPath(row: lastRowIndex, section: lastSection)
            base.insertRows(at: [indexPath], with: .none)
            if scrollToBottom {  base.scrollToRow(at: indexPath, at: .none, animated: false) }
        }
    }
    
    func reloadToLastRow(_ lastRow: Int) {
        DispatchQueue.main.async {
            let lastSection = base.numberOfSections - 1
            let lastRowIndex = base.numberOfRows(inSection: lastSection)
            guard lastRowIndex > lastRow else { return }
            let indexPath = IndexPath(row: lastRowIndex - lastRow, section: lastSection)
            base.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func scrollToBottom(_ animated: Bool = true) {
        DispatchQueue.main.async {
            if (base.numberOfSections > 0) {
                let lastSection = base.numberOfSections - 1
                let rows = base.numberOfRows(inSection: lastSection)
                if (rows > 0 ) {
                    let lastRowIndex = rows - 1
                    let indexPath = IndexPath(row: lastRowIndex, section: lastSection)
                    base.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
            }
        }
    }
    
    func setOffsetToBottom(animated: Bool) {
        base.setContentOffset(CGPoint(x: 0, y: base.contentSize.height - base.frame.size.height), animated: true)
    }
    
}
