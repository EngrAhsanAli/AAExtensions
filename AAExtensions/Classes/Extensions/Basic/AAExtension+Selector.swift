//
//  AAExtension+Selector.swift
//  AAExtensions
//
//  Created by Muhammad Ahsan Ali on 2020/04/30.
//


extension Selector {
    
    mutating func aa_addCallback( _ closure: @escaping ()->()) {
        let sleeve = AAClosureSleeve(closure)
        self = #selector(AAClosureSleeve.invoke)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, .OBJC_ASSOCIATION_RETAIN)
    }
    
}
