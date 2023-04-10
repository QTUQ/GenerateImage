//
//  ClassUILabel.swift
//  SmartSketch
//
//  Created by Tuqa on 3/28/23.
//

import Foundation
import UIKit

class GradientLabel: UILabel {
    
    var gradientColors: [CGColor] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func draw(_ rect: CGRect) {
        
        // begin new image context to let the superclass draw the text in (so we can use it as a mask)
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        do {
            // get your image context
            let ctx = UIGraphicsGetCurrentContext()
            
            // flip context
            ctx!.scaleBy(x: 1, y: -1)
            ctx!.translateBy(x: 0, y: -bounds.size.height)
            
            // get the superclass to draw text
            super.draw(rect)
        }
        
        // get image and end context
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // get drawRect context
        let ctx = UIGraphicsGetCurrentContext()
        
        // clip context to image
        ctx!.clip(to: bounds, mask: (img?.cgImage!)!)
        
        // define the colors and locations
        let colors = gradientColors
        let locs:[CGFloat] = [0.0, 1.0]
        
        // create the gradient
        let grad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: locs)!
        
        // draw gradient
        ctx!.drawLinearGradient(grad, start: CGPoint(x: 0, y:bounds.size.height*0.5), end: CGPoint(x:bounds.size.width, y:bounds.size.height*0.5), options: CGGradientDrawingOptions(rawValue: 0))
    }
    private func setup() {
        // set the gradient colors
        let startColor = UIColor(named: "StartPointColor")!.cgColor
        let endColor = UIColor(named: "EndPointColor")!.cgColor
        self.gradientColors = [startColor, endColor]
    }
}

