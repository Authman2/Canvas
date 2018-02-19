//
//  Helpers.swift
//  Canvas
//
//  Created by Adeola Uthman on 1/10/18.
//

import Foundation


/** Returns the midpoint between two points. */
func midpoint(a: CGPoint, b: CGPoint) -> CGPoint {
    return CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2)
}


/** Extension to UIImage that allows the adding of multiple images. */
public extension UIImage {
    
    public static func +(lhs: UIImage, rhs: UIImage) -> UIImage {
        let nWidth = max(lhs.size.width, rhs.size.width)
        let nHeight = max(lhs.size.height, rhs.size.height)
        let nSize = CGSize(width: nWidth, height: nHeight)
        
        UIGraphicsBeginImageContext(nSize)
        
        let lhsX = round((nSize.width - lhs.size.width) / 2)
        let lhsY = round((nSize.height - lhs.size.height) / 2)
        
        let rhsX = round((nSize.width - rhs.size.width) / 2)
        let rhsY = round((nSize.height - rhs.size.height) / 2)
        
        lhs.draw(at: CGPoint(x: lhsX, y: lhsY))
        rhs.draw(at: CGPoint(x: rhsX, y: rhsY))
        
        let combine: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return combine
    }
    
    
    
    /** Returns this UIImage, but dimmed with the specified opacity. */
    func withOpacity(_ value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        var img: UIImage = UIImage()
        if let context = UIGraphicsGetCurrentContext() {
            let area = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0, y: -area.size.height)
            context.setBlendMode(.multiply)
            context.setAlpha(value)
            context.draw(cgImage!, in: area)
            img = UIGraphicsGetImageFromCurrentImageContext()!
        }
        UIGraphicsEndImageContext()
        return img
    }
    
}
