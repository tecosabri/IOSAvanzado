//
//  UIImageViewE.swift
//  DragonBall
//
//  Created by Ismael Sabri Pérez on 10/7/22.
//

import Foundation
import UIKit


extension UIImageView {
    
    typealias ImageCompletion = (UIImage?) -> (Void)
    
    func setImage(url: String){
        guard let url = URL(string: url) else {return}
        downloadImage(withUrl: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
    
    private func downloadImage(withUrl url: URL, completion: @escaping ImageCompletion){
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
            guard let data = data,
                  let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }
            
            completion(image)
        }.resume()
    }
}
