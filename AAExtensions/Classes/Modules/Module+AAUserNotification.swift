//
//  Module+AAUserNotification.swift
//  AAExtensions
//
//  Created by Muhammad Ahsan Ali on 2020/05/04.
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

public enum AAPermissionState: Int {
    case notDetermined = 0
    case denied = 1
    case authorized = 2
    case provisional = 3
    case granted = -10
    case unknown = -11
    
}

open class AAUserNotification: NSObject {
    
    var permissionState: AAPermissionState = .unknown {
        didSet {
            onPermissionChange?(permissionState)
        }
    }
    
    open var didReceive: (([AnyHashable : Any]) -> ())?
    
    open var onPermissionChange: ((AAPermissionState) -> ())?

    open func requestAuthorization() {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] (granted, error) in
                
                self?.permissionState = granted ? .granted : .denied
                
                if !granted {
                    print("Please enable \"Notifications\" from App Settings.")
                }
                else {
                    self?.getNotificationSettings()
                }
            }
        } else {
            
            let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
        
    }
    
    open func openAppSettings() {

        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl)
            } else {
                UIApplication.shared.openURL(settingsUrl)
            }
        }
    }
    
    @available(iOS 10.0, *)
    open func getNotificationSettings() {

        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            self.permissionState = AAPermissionState(rawValue: settings.authorizationStatus.rawValue) ?? .unknown
            
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
}

@available(iOS 10, *)
extension AAUserNotification: UNUserNotificationCenterDelegate {

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) ->
        Void) {
        
        let userInfo = notification.request.content.userInfo
        print("AAExtensions:- Userinfo :\(userInfo)")
        completionHandler([.alert, .badge, .sound])
      
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.didReceive?(response.notification.request.content.userInfo)
    }
}
