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

import AVFoundation
import SystemConfiguration

// MARK:- AAHelper
open class AA_Helper {
 
    private init() { }
    
    public static let shared = AA_Helper()
    
}

// MARK: - AAHelper methods
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
                print("AAExtensions:- Error Creating Video Thumbnail")
            }
        }
    }
    
    func aa_replaceRootViewController(
        to viewController: UIViewController,
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        options: UIView.AnimationOptions = .transitionFlipFromRight,
        _ completion: AACompletionVoid? = nil) {
        
        let keyWindow = UIApplication.shared.keyWindow!

        guard animated else {
            keyWindow.rootViewController = viewController
            completion?()
            return
        }
        
        UIView.transition(with: keyWindow, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            keyWindow.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }, completion: { _ in
            completion?()
        })
    }
    
    /// returns current country name and country code
    var aa_currentCountry: (String, String) {
        let countryLocale = NSLocale.current
        let countryCode = countryLocale.regionCode!
        let country = (countryLocale as NSLocale)
            .displayName(forKey: NSLocale.Key.countryCode, value: countryCode)!
        return (country, countryCode)
    }
    
    func aa_getLangName(identifier: String) -> String {
        let locale = NSLocale(localeIdentifier: identifier)
        return locale.displayName(forKey: NSLocale.Key.identifier , value: identifier)!
    }
    
    func aa_performBackground(delay: Double = 0.0,
                              background: AACompletionVoid? = nil,
                              completion: AACompletionVoid? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
    
    func aa_viewController<T: UIViewController>(_ viewController: T.Type, instance: ((T) -> ())? = nil, inStroryboard: UIStoryboard? = nil) -> UIViewController? {
        
        var storyboard: UIStoryboard
        if let _storyboard = inStroryboard { storyboard = _storyboard }
        else { storyboard = UIStoryboard(name: String(describing: viewController), bundle: nil) }
        
        guard let vc = (inStroryboard ?? storyboard).aa_viewController(withClass: viewController) else { return nil }
        instance?(vc)
        return vc
    }
}

