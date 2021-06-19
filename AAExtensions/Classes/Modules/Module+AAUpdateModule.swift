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
    
    var countryParam: String?
    
    public init(countryCode: String?) {
        if let countryCode = countryCode {
            self.countryParam = "&country=\(countryCode)"
        }
    }
    
    open func fetchUpdate(completion: @escaping () -> ()) {
        guard let info = Bundle.main.infoDictionary,
              let currentVersion = info["CFBundleShortVersionString"] as? String,
              let identifier = info["CFBundleIdentifier"] as? String,
              let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)\(countryParam ?? "")") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let result = try JSONDecoder().decode(LookupResult.self, from: data)
                guard let info = result.results.first else { throw VersionError.invalidResponse }
                
                let appStoreAppVersion = info.version.replacingOccurrences(of: ".", with: "").aa_toInt
                let currentVersion = currentVersion.replacingOccurrences(of: ".", with: "").aa_toInt
                
                if appStoreAppVersion > currentVersion {
                    DispatchQueue.main.async(execute: completion)
                }
                
            } catch { print(error) }
        }.resume()
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
