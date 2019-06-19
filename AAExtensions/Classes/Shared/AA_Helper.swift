//
//  Helper.swift
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

import Foundation
import AVFoundation
import SystemConfiguration

// MARK:- AA_Helper
open class AA_Helper {
 
    private init() { }
    
    public static let shared = AA_Helper()
    
}

// MARK: - AA_Helper methods
public extension AA_Helper {
    
    var aa_appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    var aa_visibleViewController: UIViewController? {
        return aa_rootVC.aa_topViewController
    }
    
    var aa_isNetworkAvailable: Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
    
    var aa_isJailBroken: Bool {
        #if arch(i386) || arch(x86_64)
        return true // true for simulators
        #else
        let fileManager = FileManager.default
        
        if (fileManager.fileExists(atPath: "/bin/bash") ||
            fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
            fileManager.fileExists(atPath: "/etc/apt")) ||
            fileManager.fileExists(atPath: "/private/var/lib/apt/") ||
            fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
            fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") {
            return true
        } else {
            return false
        }
        #endif
    }
    
    func aa_isfileExist(fileName : String) -> String? {
        
        var documentsUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as URL
        documentsUrl = documentsUrl.appendingPathComponent(fileName)
        let documentsPath = documentsUrl.path
        if FileManager.default.fileExists(atPath: documentsPath) {
            return documentsPath
        }
        return nil
    }
    
    var aa_deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    func aa_setStatusBarStyle(_ style: UIStatusBarStyle) {
        guard let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView else { return }
        statusBar.backgroundColor = style == .lightContent ? .clear : .white
        statusBar.setValue(style == .lightContent ? UIColor.white : .black, forKey: "foregroundColor")
    }
    
    func aa_setStatusBar(_ color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    func aa_videoThumb(videoURL: String,
                       completion: @escaping ((UIImage) -> ())) {
        DispatchQueue.global(qos: .userInitiated).async {
            let asset = AVAsset(url: URL(string: videoURL)!)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            let time = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 100)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: img)
                DispatchQueue.main.async {
                    completion(thumbnail)
                }
            } catch {
                print("\(AA_TAG) Error Creating Video Thumbnail")
            }
        }
    }
    
    func aa_navBarAppearance(bg: UIImage, tintColor: UIColor, height: CGFloat) {
        let appearance = UINavigationBar.appearance()
        appearance.setBackgroundImage(bg, for: .default)
        appearance.isTranslucent = false
        appearance.barTintColor = tintColor
        appearance.tintColor = tintColor
        appearance.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: tintColor ]
        appearance.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
    }
    
    func aa_toolBarAppearance(bg: UIImage, barTintColor: UIColor, tintColor: UIColor) {
        let appearance = UIToolbar.appearance()
        
        appearance.barTintColor = barTintColor
        appearance.tintColor = tintColor
        
    }
    
    func aa_tabBarAppearance(bg: UIImage, tintColor: UIColor, font: UIFont, foregroundColor: UIColor) {
        let appearance = UITabBarItem.appearance()
        
        appearance.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: tintColor as Any
            ], for: .selected)
        
        appearance.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: tintColor as Any
            ], for: .normal)
        
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: font as Any, NSAttributedString.Key.foregroundColor: foregroundColor], for: .normal)
        
        if #available(iOS 11.0, *) {
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIDocumentBrowserViewController.self]).setTitleTextAttributes([
                .foregroundColor : tintColor as Any
                ], for: .normal)
        }
        
    }
}

