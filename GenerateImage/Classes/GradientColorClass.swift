//
//  GradientColor.swift
//  GEELY
//
//  Created by Tuqa on 1/24/23.
//

import Foundation
import UIKit

class GradientColor {
    static let graadientColorInstance = GradientColor()
    // making the a reusable gradient Color utility function, which can easily apply the same gradient to multiple Views, without having to duplicate the same code multiple times
    func InsertGradientColor(view: UIView, frame: CGRect, colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint, cornerRadius: CGFloat) {
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.frame =  frame
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        view.layer.cornerRadius = cornerRadius
        gradient.cornerRadius = cornerRadius
        view.layer.insertSublayer(gradient, at: 0)
    }
}
