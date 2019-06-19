//
//  AA_Constants.swift
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


/// Constant variables
var AA_AssociationKeyMaxLength: Int = 0
var AA_AssociationKeyAnyCallback: Int = 0

let AA_TAG = "AAExtensions:- "

/// Contant typealias
public typealias AACompletionVoid  = (() -> ())
public typealias AACompletionAny   = ((Any) -> ())

/// Constant computations
public var aa_rootVC: UIViewController { return UIApplication.shared.keyWindow!.rootViewController! }

public let AAHelper = { return AA_Helper.shared }()

// MARK: - Extenders and default strings

/* Can extend
 extension String.AARegularExpressions {
 static var test = ""
 }
 if regex.rawValue == AARegularExpressions.test { }
 */

/// AARegularExpressions
public enum AARegularExpressions: String {
    case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    case url = "((www\\.|(http|https)+\\:\\/\\/)?[&#95;a-z0-9-]+\\.[a-z0-9\\/&#95;_:@=.+?,##%&~-]*[^.|\'|\\# |!|\\(|?|,| |>|<|;|\\)])"
    case alphanumeric = "[\\d[A-Za-z]]+"
    case alpha = "[a-zA-Z]+"
    case base64 = "(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?"
    case hex_color = "#?([0-9A-F]{3}|[0-9A-F]{6})"
    case hexa_decimal = "[0-9A-F]+"
    case ascii = "[\\x00-\\x7F]+"
    case numeric = "[-+]?[0-9]+"
    case float = "([\\+-]?\\d+)?\\.?\\d*([eE][\\+-]\\d+)?"
    case creditcard =  "(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])case [0-9]{11}|(?:2131|1800|35\\d{3})\\d{11})"
}



/// AADateFormatters
public enum AADateFormatters: String {
    case format1 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"             // 2019-06-15T08:40:19+000000
    case format2 = "EEEE, MMM d, yyyy"                      // Saturday, Jun 15, 2019
    case format3 = "MM/dd/yyyy"                             // 06/15/2019
    case format4 = "MM-dd-yyyy HH:mm"                       // 06-15-2019 08:40
    case format5 = "MMM d, h:mm a"                          // Jun 15, 8:40 AM
    case format6 = "MMMM yyyy"                              // June 2019
    case format7 = "MMM d, yyyy"                            // Jun 15, 2019
    case format8 = "E, d MMM yyyy HH:mm:ss Z"               // Sat, 15 Jun 2019 08:40:19 +0000
    case format9 = "yyyy-MM-dd'T'HH:mm:ssZ"                 // 2019-06-15T08:40:19+0000
    case format10 = "dd.MM.yy"                              // 15.06.19
    case format11 = "HH:mm:ss.SSS"                          // 08:40:19.200
    case format12 = "yyyy-MM-dd"                            // 2019-15-06
    case format13 = "dd MMM, yyyy"                          // 06 June, 2019
    case format14 = "yyyy-MM-dd HH:mm:ss"                   // 2019-06-16 08:47:45
    case format15 = "MMM dd : HH:mm a"                      // Jun 16 : 08:47 AM
    
}

/// AATextType
public enum AATextType {
    case emailAddress, password, generic
}
