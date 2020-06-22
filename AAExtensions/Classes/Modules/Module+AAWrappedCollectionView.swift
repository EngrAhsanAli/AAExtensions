//
//  Module+AAWrappedCollectionView.swift
//  EspForms
//
//  Created by Muhammad Ahsan Ali on 2020/05/22.
//  Copyright © 2020 Exceed. All rights reserved.
//

import UIKit

public class AAWrappedCollectionView<T>: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var layout: UICollectionViewFlowLayout
    let reuseId: String
    
    public var dataSource: [T] = []
    
    public lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        return collection
    }()
    
    public var cellForItemAt: ((UICollectionViewCell, IndexPath) -> ())?
    public var sizeForItemAt: ((IndexPath) -> (CGSize))?
    public var didSelectItemAt: ((UICollectionViewCell, IndexPath) -> ())?
    
    public init(_ dataSource: [T], reuseId: String, layout: UICollectionViewFlowLayout) {
        self.layout = layout
        self.dataSource = dataSource
        self.reuseId = reuseId
        super.init(frame: .zero)
        addSubview(collectionView)
    }
    
    public func setLaytout(_ layout: UICollectionViewFlowLayout, vertical: Bool) {
        guard !vertical else {
            return
        }
        self.layout = layout
        layout.scrollDirection = vertical ? .vertical : .horizontal
        collectionView.collectionViewLayout = layout
        
    }
    
    public func addItem(_ item: T) {
        
        dataSource.append(item)
        collectionView.performBatchUpdates({
            self.collectionView.insertItems(at: [IndexPath(row: dataSource.count-1, section: 0)])
        }, completion: nil)
        
    }
    
    public func setDataSource(_ tags: [T]){
        
        UIView.animate(withDuration: 0.3) {
            self.dataSource = tags
            self.collectionView.reloadData()
        }
    }
    
    override public func layoutSubviews() {
        collectionView.frame = .init(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open var selectedItems: [T] {
        collectionView.indexPathsForSelectedItems?.compactMap({
            self.dataSource[$0.row]
        }) ?? []
    }
 
    //MARK:--UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath)
        cellForItemAt?(cell, indexPath)
        return cell
    }
    
    
    
    //MARK:--UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItemAt?(indexPath) ?? .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        didSelectItemAt?(cell, indexPath)
    }
    
}


public extension AAWrappedCollectionView {
    
    func removeItem(cell: UICollectionViewCell) {
        
        guard let index = collectionView.indexPath(for: cell) else{return}
        self.dataSource.remove(at: index.row)
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [index])
        }, completion: nil)
        
    }
}
