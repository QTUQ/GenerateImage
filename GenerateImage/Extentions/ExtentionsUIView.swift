//
//  File.swift
//  GEELY
//
//  Created by Tuqa on 12/19/22.
//

import Foundation
import UIKit
//MARK: - reuseable Shadow UIView
extension UIView {
    func dropShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}
