//
//  AAExtension+PHAsset.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

import Photos

//MARK:- PHAsset
public extension PHAsset {
    public var aa_image: UIImage? {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: self, options: options) { data, _, _, _ in
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
}
