//
//  AAExtension+Dictionary.swift
//  AAExtensions
//
//  Created by MacBook Pro on 17/03/2019.
//

// MARK:- Dictionary
public extension Dictionary {
    var aa_json: String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
    }
    
    func aa_printJson() {
        print(aa_json ?? "AAExtension: Invalid JSON String")
    }
    
}
