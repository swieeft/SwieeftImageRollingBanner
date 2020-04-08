//
//  UIImageViewExtension.swift
//  SwieeftImageRollingBanner
//
//  Created by Park GilNam on 2020/04/08.
//  Copyright © 2020 swieeft. All rights reserved.
//

import UIKit

class Cache {
    static let imageCache = NSCache<NSString, UIImage>()
}

extension UIImageView {
    
    func imageDownload(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        if let cacheImage = Cache.imageCache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async() { [weak self] in
                self?.contentMode = mode
                self?.image = cacheImage
            }
        }
        else {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else {
                        print("Download image fail : \(url)")
                        return
                }

                DispatchQueue.main.async() { [weak self] in
                    print("Download image success \(url)")

                    Cache.imageCache.setObject(image, forKey: url.absoluteString as NSString)

                    self?.contentMode = mode
                    self?.image = image
                }
            }.resume()
        }
    }
    
    func imageDownload(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else {
            return
        }

        imageDownload(url: url, contentMode: mode)
    }
}


