//
//  UIImage.swift
//  Test Enaza
//
//  Created by Andrew Krotov on 17/04/2019.
//  Copyright © 2019 Andrew Krotov. All rights reserved.
//

import UIKit

public extension UIImage {
    /// Scale image to fit in fitSize
    func scaled(fit fitSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio = fitSize.width / size.width
        let heightRatio = fitSize.height / size.height
        
        var newSize: CGSize
        
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        return scaled(to: newSize)
    }
    
    /// Scale image to newSize
    func scaled(to newSize: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        
        draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
}
