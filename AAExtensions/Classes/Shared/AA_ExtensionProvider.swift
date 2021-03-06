//
//  AA_ExtensionProvider.swift
//  AAExtensions
//
//  Created by Muhammad Ahsan Ali on 2020/05/03.
//


public protocol AAExtensionsProvider: AnyObject {
    associatedtype CompatibleType
    var aa: CompatibleType { get }
}

extension AAExtensionsProvider {
    /// A proxy which hosts reactive extensions for `self`.
    public var aa: AA<Self> { AA(self) }
}

public struct AA<Base> {
    public let base: Base
    fileprivate init(_ base: Base) { self.base = base }
}

extension UIView:               AAExtensionsProvider {}
extension UIImage:              AAExtensionsProvider {}
extension UIFont:               AAExtensionsProvider {}
extension UIViewController:     AAExtensionsProvider {}
