//
//  Module+LoadImage.swift
//  AAExtensions
//
//  Created by Muhammad Ahsan Ali on 2021/04/04.
//

/// Global cache for downloaded UIImage
fileprivate let ImageCache = NSCache<NSString, AnyObject>()

public extension AA where Base: UIImageView {
        
    /// Fetches the UIImage from the network or cache
    ///
    /// - Parameters:
    ///   - urlString: Request URL
    ///   - placeholder: placeholder
    @discardableResult
    func loadImage(withUrl urlString : String, placeholder: UIImage?) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else { return nil }
        
        if let placeholder = placeholder { base.image = placeholder }
        
        // check cached image
        if let cachedImage = ImageCache.object(forKey: urlString as NSString) as? UIImage {
            base.image = cachedImage
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
                    base.image = image
                }
            }
            
        })
        
        task.resume()
        return task
    }
}
