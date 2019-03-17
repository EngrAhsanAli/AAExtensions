//
//  Constants.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

var AA_AssociationKeyMaxLength: Int = 0
var AA_AssociationKeyAnyCallback: Int = 0

let rootVC: UIViewController! = { return UIApplication.shared.keyWindow!.rootViewController }()

class AAClosureSleeve {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}
