//
//  Extension+UICollectionView.swift
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


// MARK:- UICollectionView
public extension UICollectionView {
    func aa_setItemsInRow(_ inRow: CGFloat = 2, multiplier: CGFloat = 1.5, spacing: CGFloat = 1.0) {
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemSpacing: CGFloat = spacing
            let width = self.bounds.width
            let size = CGSize(width: (width/inRow)-(itemSpacing*multiplier), height: (width/inRow)-(itemSpacing*multiplier))
            layout.itemSize = size
            layout.sectionInset = UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: itemSpacing)
            layout.minimumInteritemSpacing = itemSpacing
            layout.minimumLineSpacing = itemSpacing
        }
    }
}
