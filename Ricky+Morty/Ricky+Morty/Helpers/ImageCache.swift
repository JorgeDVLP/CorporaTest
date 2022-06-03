//
//  ImageCache.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import UIKit

final class ImageCache {
    
    static private var cache: NSCache<NSString, NSData> = NSCache()

    private init() {}
    
    static func loadImage(urlString: String, completion: @escaping(_ image: UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        if let imgData = cache.object(forKey: urlString as NSString) {
            print("Returning cached image")
            let image = UIImage(data: imgData as Data)
            completion(image)
            return
        }
        
        print("Fetching image from network")
        URLSession.shared.dataTask(with: url) { data, _, _ in
            
            guard let data = data else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            self.cache.setObject(data as NSData, forKey: urlString as NSString)
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
