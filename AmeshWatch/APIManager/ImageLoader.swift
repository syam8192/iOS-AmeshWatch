//
//  ImageLoader.swift
//  AmeshWatch
//
//  Created by 山上 忍 on 2018/01/22.
//

import UIKit

class ImageLoader: NSObject {
    
    static let shared = ImageLoader()
    let imageCache = NSCache<NSString, UIImage>()

    func load(with url: URL, completion: ((UIImage?)->())?) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion?(cachedImage)
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error:Error?) -> Void in
            guard let data: Data = data, let image: UIImage = UIImage(data: data) else {
                print("Couldn't get image data.\n  url= \(url.absoluteString)\n  err = \(String(describing: error))")
                completion?(nil)
                return
            }
            completion?(image)
            self?.imageCache.setObject(image, forKey: url.absoluteString as NSString)
        }).resume()
    }

}
