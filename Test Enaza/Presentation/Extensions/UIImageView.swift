//
//  UIImageView.swift
//  Test Enaza
//
//  Created by Andrew Krotov on 20/04/2019.
//  Copyright © 2019 Andrew Krotov. All rights reserved.
//

import NetworkExtension
import UIKit

extension UIImageView {
    func downloaded(from link: String) {
        guard let url = URL(string: "https://static-cdn.enazadev.ru/" + link) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
}
