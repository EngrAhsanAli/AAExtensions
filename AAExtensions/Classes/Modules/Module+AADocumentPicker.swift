//
//  Module+AADocumentPicker.swift
//  AAExtensions
//
//  Created by Muhammad Ahsan Ali on 2020/05/01.
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

import UIKit
import MobileCoreServices


public extension AA where Base: UIViewController {
    
    func presentDocumentPicker(_ extensions: String?, callback: @escaping (URL?) -> ()) {
        WrappedFilePicker.shared.present(allowdExtensions: extensions, presenter: self.base, callback: callback)
    }
    
}

fileprivate class WrappedFilePicker: NSObject, UIDocumentPickerDelegate {

    static let shared = WrappedFilePicker()
    
    private var callback : ((URL?) -> ())?

    func present(allowdExtensions: String?, presenter:UIViewController, callback: @escaping (URL?) -> ()) {
        let controller = UIDocumentPickerViewController(documentTypes: parseFileTypes(allowdExtensions), in: .import)
        controller.delegate = self
        self.callback = callback
        controller.modalPresentationStyle = .formSheet
        presenter.present(controller, animated: true, completion: nil)
    }
    
    func parseFileTypes(_ allowdExtensions: String?) -> [String] {
        guard let allowdExtensions = allowdExtensions else {
            return ["public.data", "public.content"]
        }
        var fileTypes = [String]()
        let fileExtensions = allowdExtensions.replacingOccurrences(of: ".", with: "")
            .components(separatedBy: ",")
        
        fileExtensions.forEach { (ex) in
            
            // https://escapetech.eu/manuals/qdrop/uti.html
            switch ex {
            case "doc", "docx":
                fileTypes.append("com.microsoft.word.doc")
                fileTypes.append("org.openxmlformats.wordprocessingml.document")
            case "xls", "xlsx":
                fileTypes.append("com.microsoft.excel.xls")
                fileTypes.append("org.openxmlformats.spreadsheetml.sheet")
            case "ppt", "pptx":
                fileTypes.append("com.microsoft.powerpoint.ppt")
                fileTypes.append("org.openxmlformats.presentationml.presentation")
            case "pdf":
                fileTypes.append("com.adobe.pdf")
            case "gif":
                fileTypes.append("com.compuserve.gif")
            case "jpeg":
                fileTypes.append("public.jpeg")
            case "png":
                fileTypes.append("public.png")
            case "rtf":
                fileTypes.append("public.rtf")
            case "txt":
                fileTypes.append("public.plain-text")
            default:
                fileTypes.append("public.\(ex)")
            }
        }

        if fileTypes.count == 0 {
            fileTypes.append("public.data")
            fileTypes.append("public.content")
        }
        return fileTypes
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("\(AA_TAG) AADocumentPicker Cancelled")
        self.callback?(nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("\(AA_TAG) AADocumentPicker URL:- \(urls)")
        self.callback?(urls.first)
    }
}
