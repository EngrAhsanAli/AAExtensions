//
//  Extension+UICollectionView.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

// MARK:- UICollectionView
public extension UICollectionView {
    public func aa_setItemsInRow(_ inRow: CGFloat = 2, spacing: CGFloat = 1.0) {
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemSpacing: CGFloat = spacing
            let width = self.bounds.width
            let size = CGSize(width: (width/inRow)-(itemSpacing*1.5), height: (width/inRow)-(itemSpacing*1.5))
            layout.itemSize = size
            layout.sectionInset = UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: itemSpacing)
            layout.minimumInteritemSpacing = itemSpacing
            layout.minimumLineSpacing = itemSpacing
        }
    }
}
