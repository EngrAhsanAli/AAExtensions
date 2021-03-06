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
    
    var appVersion: String? { Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String }
    
    var udid: String { UIDevice.current.identifierForVendor?.uuidString ?? "iossimulator" }
    
    var visibleViewController: UIViewController? { aa_rootVC.aa.topViewController }
    
    var isConnectedToNetwork: Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
        
    }
    
    var safeAreaInsets: (CGFloat, CGFloat) {
        var topSafeAreaHeight: CGFloat = 0
        var bottomSafeAreaHeight: CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            topSafeAreaHeight = safeFrame.minY
            bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        }
        return (topSafeAreaHeight, bottomSafeAreaHeight)
    }
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            
            var safeAreaInset: CGFloat?
            if (UIApplication.shared.statusBarOrientation == .portrait) {
                safeAreaInset = UIApplication.shared.delegate?.window??.safeAreaInsets.top
            }
            else if (UIApplication.shared.statusBarOrientation == .landscapeLeft) {
                safeAreaInset = UIApplication.shared.delegate?.window??.safeAreaInsets.left
            }
            else if (UIApplication.shared.statusBarOrientation == .landscapeRight) {
                safeAreaInset = UIApplication.shared.delegate?.window??.safeAreaInsets.right
            }
            return safeAreaInset ?? 0 > 24
        }
        return false
    }
    
    var isNetworkAvailable: Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { SCNetworkReachabilityCreateWithAddress(nil, $0) }
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
    
    var isJailBroken: Bool {
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
    
    func isfileExist(fileName : String) -> String? {
        
        var documentsUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as URL
        documentsUrl = documentsUrl.appendingPathComponent(fileName)
        let documentsPath = documentsUrl.path
        if FileManager.default.fileExists(atPath: documentsPath) {
            return documentsPath
        }
        return nil
    }
    
    var deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    func videoThumb(videoURL: String,
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
    
    func navBarAppearance(bg: UIImage, tintColor: UIColor, height: CGFloat) {
        let appearance = UINavigationBar.appearance()
        appearance.setBackgroundImage(bg, for: .default)
        appearance.isTranslucent = false
        appearance.barTintColor = tintColor
        appearance.tintColor = tintColor
        appearance.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: tintColor ]
        appearance.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
    }
    
    func tabBarAppearance(bg: UIImage, tintColor: UIColor, font: UIFont, foregroundColor: UIColor) {
        let appearance = UITabBarItem.appearance()
        appearance.setTitleTextAttributes([.foregroundColor: tintColor as Any], for: .selected)
        appearance.setTitleTextAttributes([.foregroundColor: tintColor as Any], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: font as Any, .foregroundColor: foregroundColor],
                                                            for: .normal)
        
        if #available(iOS 11.0, *) {
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIDocumentBrowserViewController.self])
                .setTitleTextAttributes([.foregroundColor : tintColor as Any], for: .normal)
        }
        
    }
    
    func mapObject<T: Codable>(_ jsonString: String, type: T.Type) -> T? {
        do {
            let objectData: Data = jsonString.data(using: .utf8)!
            let jsonArray = try JSONSerialization.jsonObject(with: objectData, options: .mutableContainers)
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            let model = try JSONDecoder().decode(T.self, from: jsonData)
            return model
        } catch {
            print(AA_TAG, error.localizedDescription)
        }
        return nil
    }
    
    func logDecoder<T: Codable>(_ type: T.Type, response: Any) {
        guard let response = response as? Data else { return }
        do {
            _ = try JSONDecoder().decode(T.self, from: response)
        }catch let jsonError {
            print(jsonError)
        }
    }
    
}

