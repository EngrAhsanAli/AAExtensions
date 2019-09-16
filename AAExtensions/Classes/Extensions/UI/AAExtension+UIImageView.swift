//
//  AAExtension+UIImageView.swift
//  AAExtensions
//
//  Created by Ahsan ALI on 16/09/2019.
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

/// Global cache for downloaded UIImage
fileprivate let ImageCache = NSCache<NSString, AnyObject>()

public extension UIImageView {
    
    
    /// Fetches the UIImage from the network or cache
    ///
    /// - Parameters:
    ///   - urlString: Request URL
    ///   - placeholder: placeholder
    @discardableResult
    func aa_loadImage(withUrl urlString : String, placeholder: UIImage?) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else { return nil }
        
        if let placeholder = placeholder {
            self.image = placeholder
        }
        
        
        // check cached image
        if let cachedImage = ImageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return nil
        }
        
        // if not, download image from url
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    ImageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
            
        })

        task.resume()
        return task
    }
}

