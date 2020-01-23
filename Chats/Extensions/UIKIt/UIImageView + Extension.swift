//
//  UIImageView + Extension.swift
//  Chats
//
//  Created by Алексей Пархоменко on 05.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    convenience init(image: UIImage, contentMode: UIView.ContentMode) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.image = image
        self.contentMode = contentMode
    }
}

extension UIImageView {
    
    func setImage(imageURL: String?) {
    
        guard let url = URL(string: imageURL ?? "") else {
            self.image = nil
            return
        }
        
        if let chachedImage = self.getCachedImage(url: url) {
            self.image = chachedImage
//            print("from cached")
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) {  (data, response, error) in
            
            guard let data = data, let response = response else {
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
//                print("from internet")
            }
            self.saveImageCache(data: data, response: response)
        }
        dataTask.resume()
    }
    
    private func getCachedImage(url: URL) -> UIImage? {
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
    
    private func saveImageCache(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
}
