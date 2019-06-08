//
//  Module+AAUpdateModule.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/05/2019.
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


/// AAUpdateModule
open class AAUpdateModule: NSObject {
    private static var _instance: AAUpdateModule?
    
    private override init() {}
    
    public static var shared: AAUpdateModule {
        if let ins = AAUpdateModule._instance {
            return ins
        }
        AAUpdateModule._instance = AAUpdateModule()
        return AAUpdateModule._instance!
    }
    
    private func getAppInfo(completion: @escaping (AppInfo?, Error?) -> Void) -> URLSessionDataTask? {
        guard let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                DispatchQueue.main.async {
                    completion(nil, VersionError.invalidBundleInfo)
                }
                return nil
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let result = try JSONDecoder().decode(LookupResult.self, from: data)
                guard let info = result.results.first else { throw VersionError.invalidResponse }
                completion(info, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
    open func present(force: Bool = false) {
        let info = Bundle.main.infoDictionary
        let currentVersion = info?["CFBundleShortVersionString"] as? String
        _ = getAppInfo { (info, error) in
            let appStoreAppVersion = info?.version
            if let error = error {
                print(error)
            } else if appStoreAppVersion!.compare(currentVersion!, options: .numeric) == .orderedDescending {
                DispatchQueue.main.async {
                    aa_rootVC.showAppUpdateAlert(Version: (info?.version)!, Force: force, AppURL: (info?.trackViewUrl)!)
                }
            }
        }
    }
    
    enum VersionError: Error {
        case invalidBundleInfo, invalidResponse
    }
    
    class LookupResult: Decodable {
        var results: [AppInfo]
    }
    
    class AppInfo: Decodable {
        var version: String
        var trackViewUrl: String
    }
}

fileprivate extension UIViewController {

    func showAppUpdateAlert( Version : String, Force: Bool, AppURL: String) {
        let versionString = "Version".aa_localized
        let updateString = "is available on AppStore".aa_localized
        let bundleName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
        let alertMessage = "\(bundleName) \(versionString) \(Version) \(updateString)."
        let alertTitle = "New Version".aa_localized
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        if !Force {
            let notNowButton = UIAlertAction(title: "Not Now".aa_localized, style: .default) { _ in }
            alertController.addAction(notNowButton)
        }
        
        let updateButton = UIAlertAction(title: "Update".aa_localized, style: .default) { (action:UIAlertAction) in
            guard let url = URL(string: AppURL) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
        alertController.addAction(updateButton)
        self.present(alertController, animated: true, completion: nil)
    }
}
