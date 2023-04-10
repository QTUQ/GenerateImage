//
//  ExtentionsUIImage.swift
//  SmartSketch
//
//  Created by Tuqa on 3/28/23.
//

import Foundation
import UIKit

// apply greadient color to images by using this reusable method
extension UIImage {
    static func gradientImage(with bounds: CGRect,colors: [CGColor],locations: [NSNumber]?) -> UIImage? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.0,y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0,y: 0.5)
        gradientLayer.cornerRadius = 5
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}
