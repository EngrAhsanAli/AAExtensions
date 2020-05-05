//
//  Module+AAKeyPathListable.swift
//  AAExtensions
//
//  Created by Muhammad Ahsan Ali on 2020/05/03.
//

import Foundation

fileprivate var _membersToKeyPaths: [String: AnyKeyPath]?

protocol DefaultValueProvider {
    init()
}

protocol AAKeyPathListable : DefaultValueProvider {
    static var allKeyPaths: [String : AnyKeyPath] { get }
}

extension AAKeyPathListable {
    
    private subscript(checkedMirrorDescendant key: String) -> Any {
        return Mirror(reflecting: self).descendant(key)!
    }
    
    public static var allKeyPaths: [String : AnyKeyPath] {
        
        if _membersToKeyPaths == nil {
            _membersToKeyPaths = [String: PartialKeyPath<Self>]()
            let mirror = Mirror(reflecting: Self())
            for case (let key?, _) in mirror.children {
                _membersToKeyPaths![key] = \Self.[checkedMirrorDescendant: key] as PartialKeyPath
            }
        }
        return _membersToKeyPaths!
      
    }
}
